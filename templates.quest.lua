local a_name, a_env = ...

local GetItemCount = C_Item.GetItemCount

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local table_add_pairs = _G["SR13-Lib"].pair_utils.table_add_pairs
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals

function a_env.GetObjectiveQuestName(objective)
   local name = QuestUtils_GetQuestName(objective.quest_id)
   -- if objective.quest_id == 72724 then print(("questnmame: %q"):format(name)) end
   return "cachenonempty", name
end

-- Calls default state function and in addition can display if starter item is still in bags even if quest is completed
function a_env.GetObjectiveStateQuest(objective)
   local state = a_env.GetLazy(objective, a_env.GetObjectiveStateDefault)

   local check_inbags
   if objective.quest_start_item_id and (
      (
         (state == 'completed') and
         (objective.quest_start_item_id) and
         (not objective.if_completed_ignore_inbags)
      ) or (
         state == "notpickedup"
      )
   )
   then check_inbags = true end
   if check_inbags then
      local in_bags = GetItemCount(objective.quest_start_item_id)
      if in_bags > 0 then
         state = "inbags"
      else
         local in_bank = GetItemCount(objective.quest_start_item_id, true)
         if in_bank > 0 then
            state = "inbank"
         end
      end
   end

   -- There's generally no way a one-time quest can "stop" being completed, so we can cache this state
   local completed_forever = (state == "completed") and (not check_inbags) and (not objective.period)
   if completed_forever then
      return "cache", state
   end

   return "ok", state
end

function a_env.GetObjectiveQuestNameAnd1stObjective(objective)
   local _, quest_name = a_env.GetObjectiveQuestName(objective)
   if not quest_name then return end

   -- TODO: get from QUEST LOG so we don't have to wait for info to load
   local quest_1st_objective = GetQuestObjectiveInfo(objective.quest_id, 1, false)
   if (not quest_1st_objective) or (quest_1st_objective == "") then return "ok", quest_name end

   quest_1st_objective = quest_1st_objective:gsub("^%d+/%d+%s+", "")
   quest_name = ("%s (%s)"):format(quest_name, quest_1st_objective)

   return "cachenonnil", quest_name
end

function a_env.GetObjectiveQuestCompleted(objective)
   if C_QuestLog.IsQuestFlaggedCompleted(objective.quest_id) then return "ok", "IsComplete" end
end

function a_env.GetObjectiveQuestPickedup(objective)
   if C_QuestLog.GetLogIndexForQuestID(objective.quest_id) then return "ok", "GetLogIndexForQuestID" end
end

function a_env.GetObjectiveQuestReadyForTurnIn(objective)
   if C_QuestLog.ReadyForTurnIn(objective.quest_id) then return "ok", "ReadyForTurnIn" end
end

function a_env.GetObjectiveQuestSingleObjectiveProgressString(objective)
   local text, objectiveType, finished, fulfilled, required = GetQuestObjectiveInfo(objective.quest_id, 1, false)
   if fulfilled and required then return "ok", fulfilled .. '/' .. required end
end

function a_env.GetObjectiveLargestIncompleteObjectiveProgressString(objective)
   local largest_fulfilled, largest_required = 0, 0
   for idx = 1, 40 do
      local text, objectiveType, finished, fulfilled, required = GetQuestObjectiveInfo(objective.quest_id, idx, false)
      if not (fulfilled and required) then break end
      if objectiveType == "progressbar" then
         required = 100
         fulfilled = GetQuestProgressBarPercent(objective.quest_id)
         -- for now consider progressbar sub-objective as always largest and just return it
         return "ok", fulfilled .. "%"
      end
      if required > largest_required then largest_fulfilled = fulfilled largest_required = required end
   end
   return "ok", largest_fulfilled .. '/' .. largest_required
end

-- Detects if periodic quest is active/available right now
-- by checking several sources in quest log, quest expiration time and if quest is shown on map
-- Test cases:
-- /dump LGO_Available_PeriodicQuestActive({ quest_id = 61815, quest_map_id = 1565 })
-- /dump LGO_Available_PeriodicQuestActive({ quest_id = 63784, quest_map_id = 1961 }) -- Korthia / Gold
-- /dump LGO_Available_PeriodicQuestActive({ quest_id = 63934, quest_map_id = 1961 }) -- Assail mail
local cache_map_quest = {}
function a_env.LGO_Available_PeriodicQuestActive(objective)
   local quest_id = objective.quest_id
   if C_QuestLog.IsQuestFlaggedCompleted(quest_id) then return "ok",  "IsQuestFlaggedCompleted" end
   if C_QuestLog.GetLogIndexForQuestID(quest_id) then return "ok", "GetLogIndexForQuestID" end
   if C_QuestLog.ReadyForTurnIn(quest_id) then return "ok", "ReadyForTurnIn" end
   -- CAN RETURN NIL for up to 30 seconds after login, QUEST_LOG_UPDATE fires when data becomes available but it has no arguments to deduce what kind of update it was
   if C_TaskQuest.GetQuestTimeLeftSeconds(quest_id) then return "ok",  "GetQuestTimeLeftSeconds" end

   local quest_map_id = objective.quest_map_id
   if quest_map_id then
      local curtime = GetTime()
      if cache_map_quest.GetTime ~= curtime then
         -- print("GetQuestsOnMap CACHE WIPE")
         wipe(cache_map_quest)
         cache_map_quest.GetTime = curtime
      end

      if not cache_map_quest[quest_map_id] then
         -- print("GetQuestsOnMap map MISS", quest_map_id)
         local info = C_TaskQuest.GetQuestsOnMap(quest_map_id)
         for idx = 1, #info do
            local entry = info[idx]
            local entry_quest_id = entry.questID
            cache_map_quest[quest_map_id .. ';' .. entry_quest_id] = true
         end
         cache_map_quest[quest_map_id] = true
      else
         -- print("GetQuestsOnMap map HIT!", quest_map_id)
      end

      if cache_map_quest[quest_map_id .. ';' .. quest_id] then
         return "ok", "GetQuestsOnMap"
      end
   end
end

local quest_template = {
   name = a_env.GetObjectiveQuestName,
   state = a_env.GetObjectiveStateQuest,
   pickedup = a_env.GetObjectiveQuestPickedup,
   turnin = a_env.GetObjectiveQuestReadyForTurnIn,
   completed = a_env.GetObjectiveQuestCompleted,
   available = true, -- by default, objectives made from this template should be more precise
   -- start_item_id     - also track when quest start item is in bags
   -- Possible additional values from other modules:
   -- achievement_id    - get name from this achievement
   -- criteria_idx      - get name from this criteria in achievement
}

local repeatable_quest_template = quest_template

a_env.quest_template = quest_template
a_env.daily_quest_template = table_merge_shallow_left({ repeatable_quest_template, { period = "daily" } })
a_env.weekly_quest_template = table_merge_shallow_left({ repeatable_quest_template, { period = "weekly" } })

function a_env.GetObjectiveNameFromAchievementID(objective)
   if not objective.achievement_id then return "cache", "<.achievement_id not set>" end
   local criteria_idx = objective.criteria_idx

   local id, name
   if criteria_idx then
      name = GetAchievementCriteriaInfo(objective.achievement_id, criteria_idx)
   else
      id, name = GetAchievementInfo(objective.achievement_id)
   end
   return "cachenonempty", name
end

a_env.daily_boss_template = table_merge_shallow_left({ a_env.daily_quest_template, { name = a_env.GetObjectiveNameFromAchievementID } })

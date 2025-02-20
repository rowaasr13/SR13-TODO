local a_name, a_env = ...

local GetItemCount = C_Item.GetItemCount

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local table_add_pairs = _G["SR13-Lib"].pair_utils.table_add_pairs
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals

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

   return "ok", state
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

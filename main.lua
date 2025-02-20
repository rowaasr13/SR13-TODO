local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local array_of_pairs_iter = _G["SR13-Lib"].pair_utils.array_of_pairs_iter

function a_env.GetObjectiveStateDefault(objective)
   local available = a_env.GetLazy(objective, 'available')
   if not available then return "ok", "not available" end

   local completed = a_env.GetLazy(objective, 'completed')
   if completed then return "ok", "completed" end

   local turnin = (objective.turnin ~= nil) and a_env.GetLazy(objective, 'turnin')
   if turnin then return "ok", "turnin" end

   if objective.pickedup == nil then
      return "ok", "available"
   else
      local pickedup = a_env.GetLazy(objective, 'pickedup')
      if pickedup then
         return "ok", "pickedup"
       else
         return "ok", "notpickedup"
      end
   end
end

function a_env.CalculateObjectivesToOutputTable(objectives, mode)
   assert(objectives, "objectives is nil")
   local output = {}

   local iter_func, iter_state, iter_var
   if mode == "array_of_pairs" then
      iter_func, iter_state, iter_var = array_of_pairs_iter(objectives)
   else
      iter_func, iter_state, iter_var = ipairs(objectives)
   end

   for idx, v1, v2 in iter_func, iter_state, iter_var do
      local objective
      if mode == "array_of_pairs" then objective = v2 else objective = v1 end

      local available = a_env.GetLazy(objective, "available")
      local state = a_env.GetLazy(objective, "state")
      local state_color = a_env.state_colors[state]
      local name = a_env.GetLazy(objective, "name")
      local info = objective.info and a_env.GetLazy(objective, "info")
      local period = objective.period and a_env.GetLazy(objective, "period")
      local progress = (state == "pickedup") and (objective.progress ~= nil) and a_env.GetLazy(objective, 'progress')

      local output_line = {
         available = available,
         state = state,
         state_color = state_color,
         progress = progress,
         name = name,
         info = info,
         period = period,
      }
      output[idx] = output_line
   end

   return output
end

-- Works with preprocessed output tables.
-- If one quest is active (pickedup/turnin/completed) then entire table is replaced with only this quest.
-- If all quest are completed, then entire table is replaced with special output from .all_completed.
-- If none of quest are completed or active, then entire table is replaced with special output from .none_active.
function a_env.OutputTableLeaveOnlyActiveQuest(output_table)
   if #output_table == 0 then return end

   local completed_count = 0
   -- (bool) all quests in group are completed (often used with random dailies/weeklies when you get one random quest from group)
   local active_objective

   for idx = 1, #output_table do
      local objective = output_table[idx]
      if objective.state == "pickedup" or objective.state == "turnin" or objective.state == "completed" then
         active_objective = objective
         if objective.state == "completed" then
            completed_count = completed_count + 1
         end
      end
   end

   if (not active_objective) and output_table.none_active then
      if output_table.debug == true then print(output_table, "none_active") end
      local objective = output_table.none_active
      wipe(output_table)
      output_table[1] = objective
      return output_table
   end

   if (completed_count == #output_table) and output_table.all_completed then
      if output_table.debug == true then print(output_table, "all_completed") end
      local objective = output_table.all_completed
      wipe(output_table)
      output_table[1] = objective
      return output_table
   end

   if (completed_count >= 1) and output_table.any_completed then
      if output_table.debug == true then print(output_table, "any_completed") end
      local objective = output_table.any_completed
      wipe(output_table)
      output_table[1] = objective
      return output_table
   end

   if active_objective then
      if output_table.debug == true then print(output_table, "active_objective") end
      wipe(output_table)
      output_table[1] = active_objective
   end

   return output_table
end

function a_env.GetObjectiveQuestName(objective)
   local name = QuestUtils_GetQuestName(objective.quest_id)
   -- if objective.quest_id == 72724 then print(("questnmame: %q"):format(name)) end
   return "cachenonempty", name
end

function a_env.GetObjectiveItemName(objective)
   local name = GetItemInfo(objective.item_id)
   return "cachenonempty", name
end

function a_env.GetObjectiveQuestNameAnd1stObjective(objective)
   local _, quest_name = a_env.GetObjectiveQuestName(objective)
   if not quest_name then return end

   -- TODO: get from QUEST LOG so we don't have to wait for info to load
   local quest_1st_objective = GetQuestObjectiveInfo(objective.quest_id, 1, false)
   quest_1st_objective = quest_1st_objective:gsub("^%d+/%d+%s+", "")
   if (not quest_1st_objective) or (quest_1st_objective == "") then return "ok", quest_name end

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


a_env.state_colors = {
   ["completed"] = GREEN_FONT_COLOR,
   ["pickedup"] = YELLOW_FONT_COLOR,
   ["turnin"] = YELLOW_FONT_COLOR,
   ["inbags"] = YELLOW_FONT_COLOR,
   ["queued"] = YELLOW_FONT_COLOR,
   ["itemmissing"] = RED_FONT_COLOR,
}

a_env.state_display_text = {
   ["pickedup"] = "picked up",
   ["turnin"] = "turn-in",
   ["notpickedup"] = "not picked up",
   ["inbags"] = "still in bags",
   ["itemmissing"] = "missing!",
}

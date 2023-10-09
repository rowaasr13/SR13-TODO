local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left

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

function a_env.CalculateObjectivesToOutputTable(objectives)
   local output = {}
   for idx = 1, #objectives do
      local objective = objectives[idx]

      local state = a_env.GetLazy(objective, "state")
      local state_color = a_env.state_colors[state]
      local name = a_env.GetLazy(objective, "name")
      local info = objective.info and a_env.GetLazy(objective, "info")
      local period = objective.period and a_env.GetLazy(objective, "period")
      local progress = (state == "pickedup") and (objective.progress ~= nil) and a_env.GetLazy(objective, 'progress')

      local output_line = {
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
-- If any quest is active (pickedup/turnin) then entire table is replaced with this quest.
-- TODO: if all quest are completed, then entire table is replaced with special provided output.
function a_env.OutputTableLeaveOnlyActiveQuest(output_table)
   for idx = 1, #output_table do
      local objective = output_table[idx]
      print(objective.name, objective.state)
      if objective.state == "pickedup" or objective.state == "turnin" then
         wipe(output_table)
         output_table[1] = objective
         return
      end
   end
end

function a_env.GetObjectiveQuestName(objective)
   return "cachenonnil", QuestUtils_GetQuestName(objective.quest_id)
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

local repeatable_quest_template = {
   name = a_env.GetObjectiveQuestName,
   state = a_env.GetObjectiveStateDefault,
   pickedup = a_env.GetObjectiveQuestPickedup,
   turnin = a_env.GetObjectiveQuestReadyForTurnIn,
   completed = a_env.GetObjectiveQuestCompleted,
   available = true, -- non-repeatable will also have dynamic "available"
}

a_env.daily_quest_template = table_merge_shallow_left({ repeatable_quest_template, { period = "daily" } })
a_env.weekly_quest_template = table_merge_shallow_left({ repeatable_quest_template, { period = "weekly" } })

a_env.state_colors = {
   ["completed"] = GREEN_FONT_COLOR,
   ["pickedup"] = YELLOW_FONT_COLOR,
   ["turnin"] = YELLOW_FONT_COLOR,
}

a_env.state_display_text = {
   ["pickedup"] = "picked up",
   ["turnin"] = "turn-in",
   ["notpickedup"] = "not picked up",
}

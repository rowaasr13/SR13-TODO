local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left

function a_env.GetObjectiveStateDefault(objective)
   local available = a_env.GetLazy(objective, 'available')
   if not available then return "ok", "not available" end

   local completed = a_env.GetLazy(objective, 'completed')
   if completed then return "ok", "completed" end

   if objective.pickedup == nil then
      return "ok", "available"
   else
      local pickedup = a_env.GetLazy(objective, 'pickedup')
      if pickedup then return "ok", "picked up" else return "ok", "not picked up" end
   end
end

function a_env.GetObjectiveQuestName(objective)
   return "cache non-nil", QuestUtils_GetQuestName(objective.quest_id)
end

function a_env.GetObjectiveQuestCompleted(objective)
   if C_QuestLog.IsQuestFlaggedCompleted(objective.quest_id) then return "ok", "IsComplete" end
end

function a_env.GetObjectiveQuestPickedup(objective)
   if C_QuestLog.GetLogIndexForQuestID(objective.quest_id) then return "ok", "GetLogIndexForQuestID" end
end

local repeatable_quest_template = {
   name = a_env.GetObjectiveQuestName,
   state = a_env.GetObjectiveStateDefault,
   pickedup = a_env.GetObjectiveQuestPickedup,
   completed = a_env.GetObjectiveQuestCompleted,
   available = true, -- non-repeatable will also have dynamic "available"
}

a_env.daily_quest_template = table_merge_shallow_left({ repeatable_quest_template, { period = "daily" } })
a_env.weekly_quest_template = table_merge_shallow_left({ repeatable_quest_template, { period = "weekly" } })

a_env.state_colors = {
   completed = GREEN_FONT_COLOR,
   ["picked up"] = YELLOW_FONT_COLOR,
}

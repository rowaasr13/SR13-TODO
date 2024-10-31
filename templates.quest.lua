local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local table_add_pairs = _G["SR13-Lib"].pair_utils.table_add_pairs
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals

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

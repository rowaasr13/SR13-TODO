local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left

-- LEVEL70

a_env.objectives.dreamsurge = {}
a_env.objectives.dreamsurge.investigation = table_merge_shallow_left({ a_env.weekly_quest_template, {
   quest_id = 77414,
   info = ("one-time, random %s Veteran"):format(EPIC_PURPLE_COLOR:WrapTextInColorCode(402)),
   expansion = 111, -- Enum.Dragonflight
   season = 2000,
   available = function(self) return not a_env.GetLazy(self, 'completed') end,
}})

a_env.objectives.dreamsurge.shaping = table_merge_shallow_left({ a_env.weekly_quest_template, {
   quest_id = 77251,
   info = ("select %s Champion"):format(EPIC_PURPLE_COLOR:WrapTextInColorCode(415)),
   progress = a_env.GetObjectiveQuestSingleObjectiveProgressString,
   expansion = 111, -- Enum.Dragonflight
   season = 2000,
   available = true, -- Check if have expansion + maxlevel
}})

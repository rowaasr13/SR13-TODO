local a_name, a_env = ...

-- LEVEL70

a_env.objectives.dreamsurge = {}
a_env.objectives.dreamsurge.investigation = {
   quest_id = 77414,
   name = a_env.GetObjectiveQuestName,
   info = ("one-time, random %s Veteran"):format(EPIC_PURPLE_COLOR:WrapTextInColorCode(402)),
   state = a_env.GetObjectiveStateDefault,
   expansion = 111, -- Enum.Dragonflight
   season = 2000,
   available = function(self) return not a_env.GetLazy(self, 'completed') end,
   pickedup = a_env.GetObjectiveQuestPickedup,
   completed = a_env.GetObjectiveQuestCompleted,
}

a_env.objectives.dreamsurge.shaping = {
   quest_id = 77251,
   name = a_env.GetObjectiveQuestName,
   info = ("select %s Champion"):format(EPIC_PURPLE_COLOR:WrapTextInColorCode(415)),
   state = a_env.GetObjectiveStateDefault,
   expansion = 111, -- Enum.Dragonflight
   season = 2000,
   available = true, -- Check if have expansion + maxlevel
   pickedup = a_env.GetObjectiveQuestPickedup,
   completed = a_env.GetObjectiveQuestCompleted,
}

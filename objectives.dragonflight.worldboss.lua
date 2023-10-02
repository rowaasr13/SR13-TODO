local a_name, a_env = ...

-- _Gobjectives.worldboss.zaqali_elders
a_env.objectives.worldboss.zaqali_elders = {
   quest_id = 74892,
   name = function(self) return "cache non-nil", QuestUtils_GetQuestName(self.quest_id) end,
   state = a_env.GetObjectiveStateDefault,
   expansion = 111, -- Enum.Dragonflight
   season = 2000,
   available = true, -- Check if have expansion
   completed = a_env.GetObjectiveQuestCompleted,
}

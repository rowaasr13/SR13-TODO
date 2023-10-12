local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left

a_env.objectives.weekly_sign = {}
a_env.objectives.weekly_sign.world_quests = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 72728 } }) -- check buff 225788, red "not picked up", level 70, В КОНЦЕ НЕДЕЛИ КВЕСТ МОЖЕТ ЕЩЁ ЖИТЬ, А БАФФА УЖЕ НЕТ!
a_env.objectives.weekly_sign.timewalking_cataclysm = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 72810, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } })
a_env.objectives.weekly_sign.timewalking_cataclysm_token = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 40786 } }) -- add: item in inventory, item in inventory+no event - throw away
a_env.objectives.weekly_sign.timewalking_burning_crusade = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 72727, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } })
a_env.objectives.weekly_sign.timewalking_burning_crusade_token = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 40168 } }) -- add: item in inventory, item in inventory+no event - throw away

a_env.objectives.darkmoon_faire = {}
a_env.objectives.darkmoon_faire.ears = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 29433, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } })


--[[
/dump C_QuestLog.GetLogIndexForQuestID(75665) -> 61
/run text, objectiveType, finished, fulfilled, required = GetQuestObjectiveInfo(75665, 1, false)

]]

--[[
Valdrakken profession weekly req: EXACTLY 44 in profession Jewelcrafting.

C_QuestLog.GetLogIndexForQuestID(72728)
C_QuestLog.GetNumQuestObjectives(75665)
C_QuestLog.GetQuestAdditionalHighlights
C_QuestLog.GetQuestLogPortraitGiver
onMap, hasLocalPOI = C_QuestLog.IsOnMap(questID)
recentlyReplayed = C_QuestLog.IsQuestReplayedRecently(questID)
readyForTurnIn = C_QuestLog.ReadyForTurnIn(questID)
C_QuestLog.SetMapForQuestPOIs(uiMapID)





a_env.objectives.dreamsurge.TEST = {
   70619 -- Skinning: Valdrakken bring leather

   70531 -- Alchemy: craft potions
   70595 -- Tailoring: orders
   70582 -- Tailoring: craft bolts
   72728 -- 10 WQ Weekly

DMF:
   29514 Herbalism
   29518 Mining

Warn if Fighting is ready for turn-in: any favor up, aiding valdrakken/niffen both picked up or completed

}


Enum.MinimapTrackingFilter.TrivialQuests

for _, questId in pairs(C_TaskQuest.GetThreatQuests()) do
   print(questId, QuestUtils_GetQuestName(questId), C_TaskQuest.IsActive(questId))
end

/dump C_TaskQuest.IsActive(77414)

]]

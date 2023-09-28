local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left

-- Enum.Profession.Mining
a_env.objectives.profession_mining = {}
a_env.objectives.profession_mining.valdrakken_serevite = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70618 } })

a_env.objectives.profession_herbalism = {}
a_env.objectives.profession_herbalism.valdrakken_saxifrage = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70615 } })

a_env.objectives.profession_enchanting = {}
a_env.objectives.profession_herbalism.valdrakken_bracer_leech = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 72173 } })

a_env.objectives.profession_blacksmithing = {}
a_env.objectives.profession_blacksmithing.valdrakken_explorer_boots = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70211 } })

a_env.objectives.profession_tailoring = {}
a_env.objectives.profession_tailoring.valdrakken_surveyor_robe = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70572 } })
a_env.objectives.profession_tailoring.valdrakken_simple_reagent_bag = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70587 } })

a_env.objectives.profession_alchemy = {}
a_env.objectives.profession_alchemy.valdrakken_reclaim = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70530 } })
a_env.objectives.profession_alchemy.valdrakken_healing_potion = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70532 } })

a_env.objectives.profession = {}
a_env.objectives.profession.valdrakken_mettle = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70221 } })

a_env.objectives.reputation = {}
a_env.objectives.reputation.loamm_niffen = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 75665 } })
a_env.objectives.reputation.valdrakken_noevent = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70750 } })
a_env.objectives.reputation.valdrakken_dragonbane = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 72374 } })
a_env.objectives.reputation.valdrakken_dreamsurge = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 77976 } })
a_env.objectives.valdrakken_heroic = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 76122 } }) -- Complete 5 Heroic, Fighting is its own reward

a_env.objectives.weekly_sign = {}
a_env.objectives.weekly_sign.world_quests = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 72728 } }) -- check buff 225788, red "not picked up", level 70, В КОНЦЕ НЕДЕЛИ КВЕСТ МОЖЕТ ЕЩЁ ЖИТЬ, А БАФФА УЖЕ НЕТ!
a_env.objectives.weekly_sign.timewalking_cataclysm = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 72810 } })

--[[
C_QuestLog.GetLogIndexForQuestID(72728)
C_QuestLog.GetNumQuestObjectives(75665)
C_QuestLog.GetQuestAdditionalHighlights
C_QuestLog.GetQuestLogPortraitGiver
onMap, hasLocalPOI = C_QuestLog.IsOnMap(questID)
recentlyReplayed = C_QuestLog.IsQuestReplayedRecently(questID)
readyForTurnIn = C_QuestLog.ReadyForTurnIn(questID)
C_QuestLog.SetMapForQuestPOIs(uiMapID)





a_env.objectives.dreamsurge.TEST = {
   76122 -- Fighting
   29433 -- /dump [Test Your Strength]
   70531 -- Alchemy: craft potions
   70595 -- Tailoring: orders

   70582 -- Tailoring: craft bolts

   72728 -- 10 WQ Weekly

   -- Brewfest:
   COREN dungeon

}


Enum.MinimapTrackingFilter.TrivialQuests

for _, questId in pairs(C_TaskQuest.GetThreatQuests()) do
   print(questId, QuestUtils_GetQuestName(questId), C_TaskQuest.IsActive(questId))
end

/dump C_TaskQuest.IsActive(77414)

]]

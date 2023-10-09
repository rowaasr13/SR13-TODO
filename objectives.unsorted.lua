local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left

a_env.PlayerHasProfession = function(objective)
   local profession_skill_line_id = C_TradeSkillUI.GetProfessionSkillLineID(objective.profession)
   if not profession_skill_line_id then return end

   local profession_local_name = C_TradeSkillUI.GetTradeSkillDisplayName(profession_skill_line_id)
   if not profession_local_name or profession_local_name == '' then return end

   local prof1, prof2 = GetProfessions()
   if prof1 then
      local name, icon = GetProfessionInfo(prof1)
      if name == profession_local_name then return "ok", "GetProfessionInfo1Name" end
   end
   if prof2 then
      local name, icon = GetProfessionInfo(prof2)
      if name == profession_local_name then return "ok", "GetProfessionInfo2Name" end
   end
end

local weekly_profession_quest_template = table_merge_shallow_left({ a_env.weekly_quest_template, {
   available = a_env.PlayerHasProfession,
   progress = a_env.GetObjectiveQuestSingleObjectiveProgressString,
} })

-- Enum.Profession.Mining
a_env.objectives.profession_mining = {}
a_env.objectives.profession_mining.valdrakken_draconium = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70617, profession = Enum.Profession.Mining } })
a_env.objectives.profession_mining.valdrakken_serevite = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70618, profession = Enum.Profession.Mining } })
a_env.objectives.profession_mining.valdrakken_earth = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 72157, profession = Enum.Profession.Mining } })

a_env.objectives.profession_herbalism = {}
a_env.objectives.profession_herbalism.valdrakken_saxifrage = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70615, profession = Enum.Profession.Herbalism } })
a_env.objectives.profession_herbalism.valdrakken_hochenblume = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70616, profession = Enum.Profession.Herbalism } })

a_env.objectives.profession_enchanting = {}
a_env.objectives.profession_enchanting.valdrakken_bracer_leech = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 72173, profession = Enum.Profession.Enchanting } })
a_env.objectives.profession_enchanting.loamm_relic = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75865, profession = Enum.Profession.Enchanting } })

a_env.objectives.profession_blacksmithing = {}
a_env.objectives.profession_blacksmithing.valdrakken_explorer_boots = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70211, profession = Enum.Profession.Blacksmithing } })
a_env.objectives.profession_blacksmithing.loamm_plate = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75569, profession = Enum.Profession.Blacksmithing } })

a_env.objectives.profession_tailoring = {}
a_env.objectives.profession_tailoring.valdrakken_surveyor_robe = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70572, profession = Enum.Profession.Tailoring } })
a_env.objectives.profession_tailoring.valdrakken_simple_reagent_bag = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70587, profession = Enum.Profession.Tailoring } })
a_env.objectives.profession_tailoring.valdrakken_orders = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70595, profession = Enum.Profession.Tailoring } })

a_env.objectives.profession_alchemy = {}
a_env.objectives.profession_alchemy.valdrakken_reclaim = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70530 } })
a_env.objectives.profession_alchemy.valdrakken_healing_potion = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70532 } })

a_env.objectives.profession = {}
a_env.objectives.profession.valdrakken_mettle = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70221 } })

a_env.objectives.profession_jewelcrafting = {}
a_env.objectives.profession_jewelcrafting.loamm_whelkshell = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75362, profession = Enum.Profession.Jewelcrafting } })

-- Enum.Profession.Inscription
a_env.objectives.profession_inscription = {}
a_env.objectives.profession_inscription.loamm_proclamation = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75573, profession = Enum.Profession.Inscription } })

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

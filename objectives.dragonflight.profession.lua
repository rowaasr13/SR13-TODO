local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local table_add_pairs = _G["SR13-Lib"].pair_utils.table_add_pairs
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals

local function GetProfessionName(objective)
   local profession_skill_line_id = C_TradeSkillUI.GetProfessionSkillLineID(objective.profession)
   if not profession_skill_line_id then return end

   local profession_local_name = C_TradeSkillUI.GetTradeSkillDisplayName(profession_skill_line_id)
   if not profession_local_name or profession_local_name == '' then return end

   return "ok", profession_local_name
end

local function GetValdrakkenProfessionQuestGroupName(objective)
   local res, profession_name = GetProfessionName(objective)
end

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
local mining_valdrakken = {
   { draconium = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70617, profession = Enum.Profession.Mining } }) },
   { serevite = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70618, profession = Enum.Profession.Mining } }) },
   { earth = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 72157, profession = Enum.Profession.Mining } }) },
}
table_add_pairs(a_env.objectives.profession_mining, mining_valdrakken)
function a_env.OutputTableMiningValdrakken()
   local output_table = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(mining_valdrakken))
   local name = "(manual) Mining Valdrakken"
   output_table.none_active   = { name = name, state = output_table[1].state, period = output_table[1].period }
   output_table.any_completed = { name = name, state = "completed",           period = output_table[1].period }

   a_env.OutputTableLeaveOnlyActiveQuest(output_table)

   return output_table
end

a_env.objectives.profession_herbalism = {}
local herbalism_valdrakken = {
   { saxifrage = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70615, profession = Enum.Profession.Herbalism } }) },
   { hochenblume = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70616, profession = Enum.Profession.Herbalism } }) },
}
table_add_pairs(a_env.objectives.profession_herbalism, herbalism_valdrakken)
function a_env.OutputTableHerbalismValdrakken()
   local output_table = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(herbalism_valdrakken))
   local name = "(manual) Herbalism Valdrakken"
   output_table.none_active   = { name = name, state = output_table[1].state, period = output_table[1].period }
   output_table.any_completed = { name = name, state = "completed",           period = output_table[1].period }

   a_env.OutputTableLeaveOnlyActiveQuest(output_table)

   return output_table
end

a_env.objectives.profession_enchanting = {}
a_env.objectives.profession_enchanting.valdrakken_bracer_leech = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 72173, profession = Enum.Profession.Enchanting } })
a_env.objectives.profession_enchanting.loamm_relic = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75865, profession = Enum.Profession.Enchanting } })

a_env.objectives.profession_blacksmithing = {}
a_env.objectives.profession_blacksmithing.valdrakken_explorer_boots = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70211, profession = Enum.Profession.Blacksmithing } })
a_env.objectives.profession_blacksmithing.loamm_plate = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75569, profession = Enum.Profession.Blacksmithing } })
a_env.objectives.profession_blacksmithing.orders = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70589, profession = Enum.Profession.Blacksmithing } })

a_env.objectives.profession_tailoring = {}
a_env.objectives.profession_tailoring.valdrakken_surveyor_robe = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70572, profession = Enum.Profession.Tailoring } })
a_env.objectives.profession_tailoring.valdrakken_simple_reagent_bag = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70587, profession = Enum.Profession.Tailoring } })
a_env.objectives.profession_tailoring.valdrakken_orders = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70595, profession = Enum.Profession.Tailoring } })

a_env.objectives.profession_alchemy = {}
a_env.objectives.profession_alchemy.valdrakken_reclaim = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70530 } })
a_env.objectives.profession_alchemy.valdrakken_mana_potion = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70531 } })
a_env.objectives.profession_alchemy.valdrakken_healing_potion = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70532 } })

a_env.objectives.profession.valdrakken_mettle = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70221 } })

a_env.objectives.profession_jewelcrafting = {}
a_env.objectives.profession_jewelcrafting.loamm_whelkshell = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75362, profession = Enum.Profession.Jewelcrafting } })

-- Enum.Profession.Inscription
a_env.objectives.profession_inscription = {}
a_env.objectives.profession_inscription.valdrakken_explorer_compendium = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70560, profession = Enum.Profession.Inscription } })
a_env.objectives.profession_inscription.loamm_proclamation = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75573, profession = Enum.Profession.Inscription } })

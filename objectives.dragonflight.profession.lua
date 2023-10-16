local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local table_add_pairs = _G["SR13-Lib"].pair_utils.table_add_pairs
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals
local array_of_pairs_iter = _G["SR13-Lib"].pair_utils.array_of_pairs_iter

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

local branch = a_env.objectives.profession

local source_data = {
   [Enum.Profession.Mining] = {
      valdrakken_weekly = {
         { draconium = { quest_id = 70617 } },
         { serevite = { quest_id = 70618 } },
         { earth = { quest_id = 72157 } },
      },
   },
   [Enum.Profession.Herbalism] = {
      valdrakken_weekly = {
         { saxifrage = { quest_id = 70615 } },
         { hochenblume = { quest_id = 70616 } },
      },
   },
   [Enum.Profession.Skinning] = {
      valdrakken_weekly = {
         { dense_hide = { quest_id = 72158 } },
      },
   },
   [Enum.Profession.Leatherworking] = {
      valdrakken_weekly = {
         { herbalist_basket = { quest_id = 70569 } },
      },
      valdrakken_orders = { quest_id = 70594 },
      loamm_weekly = {
         { mycelium = { quest_id = 75354 } },
      },
   },
   [Enum.Profession.Alchemy] = {
      valdrakken_weekly = {
         { reclaim = { quest_id = 70530 } },
         { mana_potion = { quest_id = 70531 } },
         { healing_potion = { quest_id = 70532 } },
      },
   },
   [Enum.Profession.Tailoring] = {
      valdrakken_weekly = {
         { surveyor_robe = { quest_id = 70572 } },
         { simple_reagent_bag = { quest_id = 70587 } },
      },
      valdrakken_orders = { quest_id = 70595 },
   },
}

local one_quest_per_group_weeklies = {
   { valdrakken_weekly = "Valdrakken" },
   { loamm_weekly = "Loamm" },
}

for profession_enum, profession_quests in pairs(source_data) do
   local prof_objs_branch = a_env.objectives.profession[profession_enum]
   if not prof_objs_branch then prof_objs_branch = {} a_env.objectives.profession[profession_enum] = prof_objs_branch end

   for idx, group_key, group_name in array_of_pairs_iter(one_quest_per_group_weeklies) do
      if profession_quests[group_key] then
         prof_objs_branch[group_key] = prof_objs_branch[group_key] or {}
         for idx, key, val in array_of_pairs_iter(profession_quests[group_key]) do
            local merged_data = table_merge_shallow_left({ weekly_profession_quest_template, { profession = profession_enum }, val })
            prof_objs_branch[group_key][key] = merged_data
            profession_quests[group_key][idx][key] = merged_data
         end
      end
      -- ORDER: if profession_quests
   end
end

function a_env.OutputTablesProfessions()
   local output_tables = {}
   for profession_enum, profession_objectives in pairs(source_data) do
      for idx, group_key, group_name in array_of_pairs_iter(one_quest_per_group_weeklies) do
         if profession_objectives[group_key] then

            local output_table = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(source_data[profession_enum][group_key]))
            local ok, prof_name = GetProfessionName({ profession = profession_enum })
            local group_name = ("%s %s"):format((prof_name or ("prof_enum:" .. profession_enum)), group_name)
            for idx = 1, #output_table do output_table[idx].info = group_name  end
            output_table.none_active   = { name = group_name, info = group_name, state = output_table[1].state, period = output_table[1].period }
            output_table.any_completed = { name = group_name, info = group_name, state = "completed",           period = output_table[1].period }

            a_env.OutputTableLeaveOnlyActiveQuest(output_table)
            output_tables[#output_tables + 1] = output_table
         end
      end
      -- ORDER: if profession_objectives
   end

   return output_tables
end

a_env.objectives.profession_enchanting = {}
a_env.objectives.profession_enchanting.valdrakken_bracer_leech = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 72173, profession = Enum.Profession.Enchanting } })
a_env.objectives.profession_enchanting.loamm_relic = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75865, profession = Enum.Profession.Enchanting } })

a_env.objectives.profession_blacksmithing = {}
a_env.objectives.profession_blacksmithing.valdrakken_explorer_boots = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70211, profession = Enum.Profession.Blacksmithing } })
a_env.objectives.profession_blacksmithing.loamm_plate = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75569, profession = Enum.Profession.Blacksmithing } })
a_env.objectives.profession_blacksmithing.orders = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70589, profession = Enum.Profession.Blacksmithing } })

a_env.objectives.profession.valdrakken_mettle = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70221 } })

a_env.objectives.profession_jewelcrafting = {}
a_env.objectives.profession_jewelcrafting.loamm_whelkshell = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75362, profession = Enum.Profession.Jewelcrafting } })

-- Enum.Profession.Inscription
a_env.objectives.profession_inscription = {}
a_env.objectives.profession_inscription.valdrakken_explorer_compendium = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70560, profession = Enum.Profession.Inscription } })
a_env.objectives.profession_inscription.loamm_proclamation = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75573, profession = Enum.Profession.Inscription } })

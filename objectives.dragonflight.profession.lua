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

local function GetNameFromQuestID(objective)
   return "ok", "quest id#" .. objective.quest_id
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
      loamm_weekly = {
         { deepflayers = { quest_id = 75363 } },
      },
   },
   [Enum.Profession.Tailoring] = {
      valdrakken_weekly = {
         { surveyor_robe = { quest_id = 70572 } },
         { chef_hat = { quest_id = 70586 } },
         { simple_reagent_bag = { quest_id = 70587 } },
      },
      item_weekly = {
         { loot_66386 = { quest_id = 66386, name = GetNameFromQuestID } },
         { loot_66387 = { quest_id = 66387, name = GetNameFromQuestID } },
         { loot_70524 = { quest_id = 70524, name = GetNameFromQuestID,  info = "Weave" } }, -- {name="Ohn'arhan Weave - Nokhud Enemies (Tailoring)", quests={70524}, optionKey="tailoring", skillID=197},
         { loot_70525 = { quest_id = 70525, name = GetNameFromQuestID, info = "Stupid" } }, -- {name="Stupidly Effective Stitchery - Gnoll Enemies (Tailoring)", quests={70525}, optionKey="tailoring", skillID=197},
         { treatise =   { quest_id = 74115, name = GetNameFromQuestID, info = "Treatise" } }, -- {name="Stupidly Effective Stitchery - Gnoll Enemies (Tailoring)", quests={70525}, optionKey="tailoring", skillID=197},
          -- {name="Valdrakken Profession Quests (Tailoring)", quests={72410, 70587, 66952, 70586, 70572, 70582, 66953, 66899}, optionKey="tailoring", skillID=197, useWorldState=true},
          -- {name="Crafting Order Quest (Tailoring)", quests={70595}, optionKey="tailoring", skillID=197},
      },
      valdrakken_orders = { quest_id = 70595 },
      loamm_weekly = {
         { silk = { quest_id = 75600 } },
      },
   },
   [Enum.Profession.Inscription] = {
      valdrakken_weekly = {
         { explorer_compendium = { quest_id = 70560 } },
         { blazing_ink = { quest_id = 70561 } },
      },
      -- loamm_proclamation = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75573, profession = Enum.Profession.Inscription } })
   },
   [Enum.Profession.Jewelcrafting] = {
      valdrakken_weekly = {
         { pendant = { quest_id = 70565 } },
      },
      valdrakken_orders = { quest_id = 70593 },
      -- loamm_proclamation = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75573, profession = Enum.Profession.Inscription } })
      -- a_env.objectives.profession_jewelcrafting.loamm_whelkshell = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75362, profession = Enum.Profession.Jewelcrafting } })

   },
   [Enum.Profession.Blacksmithing] = {
      valdrakken_weekly = {
         { explorer_boots = { quest_id = 70211 } },
         { draconium_hammer = { quest_id = 70234 } },
      },
      loamm_weekly = {
         { lava_blades = { quest_id = 75148 } },
      },
      -- a_env.objectives.profession_blacksmithing.loamm_plate = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75569, profession = Enum.Profession.Blacksmithing } })
      -- a_env.objectives.profession_blacksmithing.orders = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70589, profession = Enum.Profession.Blacksmithing } })
   },
   [Enum.Profession.Enchanting] = {
      valdrakken_weekly = {
         { chromatic_dust = { quest_id = 72172 } },
         { bracer_leech = { quest_id = 72173 } },
      },
      item_weekly = {
         { loot_66377 = { quest_id = 66377, name = GetNameFromQuestID } },
         { loot_66378 = { quest_id = 66377, name = GetNameFromQuestID } },
         { loot_70514 = { quest_id = 70514, name = GetNameFromQuestID, info = "Primordial Aether - Arcane Enemies (i.e. Academy)" } },
         { loot_70515 = { quest_id = 70515, name = GetNameFromQuestID, info = "Primalist Charm - Humanoid Primalist Enemies (Druids of Fire?)" } },
         -- { treatise =   { quest_id = 74115, name = GetNameFromQuestID, info = "Treatise" } }, -- {name="Stupidly Effective Stitchery - Gnoll Enemies (Tailoring)", quests={70525}, optionKey="tailoring", skillID=197},
      },
      loamm_weekly = {
         { fireshards = { quest_id = 75150 } },
      },
      -- a_env.objectives.profession_enchanting.loamm_relic = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75865, profession = Enum.Profession.Enchanting } })
    -- {name="Draconic Treatise (Enchanting)", quests={74110}, optionKey="enchanting", skillID=333},
    -- {name="Valdrakken Profession Quests (Enchanting)", quests={66884, 66900, 66935, 72155, 72172, 72173, 72175, 72423}, optionKey="enchanting", skillID=333, useWorldState=true},
   },
}

local one_quest_per_group_weeklies = {
   { valdrakken_weekly = "Valdrakken" },
   { loamm_weekly = "Loamm" },
}

-- Combination of array_of_pairs_iter + table_merge_shallow_left
-- Iterates over all pairs in array, merges everything to left and writes back to "value" part of pairs.
-- Value of pair is assumed to be last in merge chain (TODO: allow setting position)
-- Returns new array of pairs
local function array_of_pairs_table_merge_shallow_left(array_of_pairs, in_array_of_tables)
   local tables_to_merge = {}
   local out_array_of_pairs = {}
   for idx = 1, #in_array_of_tables do
      tables_to_merge[idx] = in_array_of_tables[idx]
   end
   local new_idx = #tables_to_merge + 1

   for idx, key, val in array_of_pairs_iter(array_of_pairs) do
      tables_to_merge[new_idx] = val
      local merged_data = table_merge_shallow_left(tables_to_merge)
      out_array_of_pairs[idx] = { key = merged_data }
   end

   return out_array_of_pairs
end

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
      local add_array_of_pairs = source_data[profession_enum].item_weekly
      if add_array_of_pairs then
         source_data[profession_enum].item_weekly = array_of_pairs_table_merge_shallow_left(source_data[profession_enum].item_weekly, { weekly_profession_quest_template, { profession = profession_enum } })
      end
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
      local add_array_of_pairs = source_data[profession_enum].item_weekly
      if add_array_of_pairs then output_tables[#output_tables + 1] = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(add_array_of_pairs)) end
   end

   return output_tables
end

a_env.objectives.profession.valdrakken_mettle = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70221 } })


--[[
Prof 44 for weekly valdrakken
25 prof level for "order?"
Loamm 3 for Zaralek quests
]]
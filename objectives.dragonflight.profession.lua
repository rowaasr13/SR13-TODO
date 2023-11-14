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

   return "cachenonempty", profession_local_name
end

a_env.PlayerHasProfession = function(objective)
   local profession_skill_line_id = C_TradeSkillUI.GetProfessionSkillLineID(objective.profession)
   if not profession_skill_line_id then return end

   local profession_local_name = C_TradeSkillUI.GetTradeSkillDisplayName(profession_skill_line_id)
   if (not profession_local_name) or profession_local_name == '' then return end

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

local function GetNameFromItemID(objective)
   local name = GetItemInfo(objective.item_id)
   return "cachenonnil", name
end

local weekly_profession_quest_template = table_merge_shallow_left({ a_env.weekly_quest_template, {
   available = a_env.PlayerHasProfession,
   progress = a_env.GetObjectiveQuestSingleObjectiveProgressString,
} })

local function GetObjectiveProfessionLootName(objective)
   local item_name = a_env.GetLazy(objective, GetNameFromItemID)
   local loot_objecitve_name = ("%s (%s)"):format((item_name or ""), objective.loot_source)
   local cache_mode = item_name and "cachenonnil" or "ok"
   return cache_mode, loot_objecitve_name
end

local function GetObjectiveProfessionLootProgress(ojective)
   local state = a_env.GetLazy(ojective, a_env.GetObjectiveStateDefault)
   if state == "completed" then
      local in_inventory = GetItemCount(ojective.item_id, true, true, true)
      if in_inventory > 0 then
         state = "inbags"
      end
   end
   return "ok", state
end

local branch = a_env.objectives.profession

-- Defines both templates for each group of quests AND their order in display
local templates = {
   { valdrakken_weekly = table_merge_shallow_left({ weekly_profession_quest_template, { name = a_env.GetObjectiveQuestNameAnd1stObjective } }) },
   { factions_weekly   = weekly_profession_quest_template },
   { item_weekly       = table_merge_shallow_left({ weekly_profession_quest_template, { name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } }) },
   { valdrakken_orders = weekly_profession_quest_template },
}

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
         { bubble = { quest_id = 70614 } },
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
         { trailblazers_bracers = { quest_id = 70568, name = a_env.GetObjectiveQuestNameAnd1stObjective } },--/dump GetItemInfo(193393)
      },
      valdrakken_orders = { only_one = { quest_id = 70594 } },
      factions_weekly = {
         { niffen_mycelium = { quest_id = 75354 } },
      },
      item_weekly = {
         { loot_1 = { quest_id = 66384, item_id = 193910, loot_source = "Treasures", name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } },
         { loot_2 = { quest_id = 66385, item_id = 193913, loot_source = "Treasures", name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } },
         { loot_3 = { quest_id = 70522, item_id = 198975, loot_source = "Proto-dragons", name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } },
         { loot_4 = { quest_id = 70523, item_id = 198976, loot_source = "Slyvern/Vorquin", name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } },
         --{ treatise =   { quest_id = 74113, name = GetNameFromQuestID, info = "Treatise" } },
      },
   },
   [Enum.Profession.Alchemy] = {
      valdrakken_weekly = {
         { reclaim = { quest_id = 70530 } },
         { mana_potion = { quest_id = 70531 } },
         { healing_potion = { quest_id = 70532 } },
      },
      factions_weekly = {
         { maruuk_lashers = { quest_id = 72427 } },
         { niffen_deepflayers = { quest_id = 75363 } },
      },
      item_weekly = {
         { loot_1 = { quest_id = 66373, item_id = 193891, loot_source = "Treasures", name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } },
      },
   },
   [Enum.Profession.Tailoring] = {
      valdrakken_weekly = {
         { surveyor_robe = { quest_id = 70572 } },
         { wildercloth_bolt = { quest_id = 70582 } },
         { chef_hat = { quest_id = 70586 } },
         { simple_reagent_bag = { quest_id = 70587 } },
      },
      item_weekly = {
         { loot_66386 = { quest_id = 66386, name = GetNameFromQuestID } },
         { loot_66387 = { quest_id = 66387, name = GetNameFromQuestID } },
         { loot_3 = { quest_id = 70524, item_id = 198977, loot_source = "Nokhud", name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } },
         { loot_4 = { quest_id = 70525, item_id = 198978, loot_source = "Gnolls", name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } },
         { treatise =   { quest_id = 74115, name = GetNameFromQuestID, info = "Treatise" } }, -- {name="Stupidly Effective Stitchery - Gnoll Enemies (Tailoring)", quests={70525}, optionKey="tailoring", skillID=197},
          -- {name="Valdrakken Profession Quests (Tailoring)", quests={72410, 70587, 66952, 70586, 70572, 70582, 66953, 66899}, optionKey="tailoring", skillID=197, useWorldState=true},
          -- {name="Crafting Order Quest (Tailoring)", quests={70595}, optionKey="tailoring", skillID=197},
      },
      valdrakken_orders = { only_one = {  quest_id = 70595 } },
      factions_weekly = {
         { niffen_cocoon = { quest_id = 75407 } },
         { niffen_silk = { quest_id = 75600 } },
      },
   },
   [Enum.Profession.Inscription] = {
      valdrakken_weekly = {
         { fastened_quill = { quest_id = 70559 } },
         { explorer_compendium = { quest_id = 70560 } },
         { blazing_ink = { quest_id = 70561 } },
      },
      item_weekly = {
         { loot_70518 = { quest_id = 70518, item_id = 198971, loot_source = "Djaradin", name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } },
         { loot_70519 = { quest_id = 70519, item_id = 198972, name = GetNameFromItemID, info = "Dragonkin/Drachtyr/Tarasek" } },
      }
      -- niffen_proclamation = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75573, profession = Enum.Profession.Inscription } })
    -- {name="Disturbed Dirt or Expedition Scout's Pack (Inscription)", quests={66375, 66376}, optionKey="inscription", skillID=773},
    -- {name="Draconic Treatise (Inscription)", quests={74105}, optionKey="inscription", skillID=773},
    -- {name="Valdrakken Profession Quests (Inscription)", quests={66943, 66944, 70559, 70561, 70558, 70560, 66945, 72438}, optionKey="inscription", skillID=773, useWorldState=true},
    -- {name="Crafting Order Quest (Inscription)", quests={70592}, optionKey="inscription", skillID=773},
   },
   [Enum.Profession.Jewelcrafting] = {
      valdrakken_weekly = {
         { pendant = { quest_id = 70565 } },
      },
      valdrakken_orders = { only_one = {  quest_id = 70593 } },
      item_weekly = {
         { loot_3 = { quest_id = 70521, item_id = 198974, loot_source = "Nokhud/Sundered Flame", name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } },
      },

      -- niffen_proclamation = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75573, profession = Enum.Profession.Inscription } })
      -- a_env.objectives.profession_jewelcrafting.niffen_whelkshell = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75362, profession = Enum.Profession.Jewelcrafting } })
      -- {name="Disturbed Dirt or Expedition Scout's Pack (Jewelcrafting)", quests={66388, 66389}, optionKey="jewelcrafting", skillID=755},
      -- {name="Incandescent Curio - Elemental Enemies (Jewelcrafting)", quests={70520}, optionKey="jewelcrafting", skillID=755},
      -- {name="Draconic Treatise (Jewelcrafting)", quests={74112}, optionKey="jewelcrafting", skillID=755},
      -- {name="Valdrakken Profession Quests (Jewelcrafting)", quests={66516, 70565, 66950, 66949, 72428, 70564, 70563, 70562}, optionKey="jewelcrafting", skillID=755, useWorldState=true},
      -- {name="Crafting Order Quest (Jewelcrafting)", quests={70593}, optionKey="jewelcrafting", skillID=755},
   },
   [Enum.Profession.Blacksmithing] = {
      valdrakken_weekly = {
         { explorer_boots = { quest_id = 70211 } },
         { draconium_axe = { quest_id = 70233 } },
         { draconium_hammer = { quest_id = 70234 } },
      },
      item_weekly = {
         { loot_1 = { quest_id = 66381, item_id = 192131, loot_source = "Treasures", name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } },
         { loot_2 = { quest_id = 66382, item_id = 192132, loot_source = "Treasures", name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } },
      },
      factions_weekly = {
         { lava_blades = { quest_id = 75148 } },
      },
    -- {name="Molten Globule - Rousing Fire Enemies (Blacksmithing)", quests={70513}, optionKey="blacksmithing", skillID=164},
    -- {name="Primeval Earth Fragment - Rousing Earth Enemies (Blacksmithing)", quests={70512}, optionKey="blacksmithing", skillID=164},
    -- {name="Draconic Treatise (Blacksmithing)", quests={74109}, optionKey="blacksmithing", skillID=164},
    -- {name="Valdrakken Profession Quests (Blacksmithing)", quests={66941, 70233, 66517, 66897, 70235, 72398, 70234, 70211}, optionKey="blacksmithing", skillID=164, useWorldState=true},
    -- {name="Crafting Order Quest (Blacksmithing)", quests={70589}, optionKey="blacksmithing", skillID=164},
      -- a_env.objectives.profession_blacksmithing.niffen_plate = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75569, profession = Enum.Profession.Blacksmithing } })
      -- a_env.objectives.profession_blacksmithing.orders = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 70589, profession = Enum.Profession.Blacksmithing } })
   },
   [Enum.Profession.Enchanting] = {
      valdrakken_weekly = {
         { chromatic_dust = { quest_id = 72172 } },
         { bracer_leech = { quest_id = 72173 } },
      },
      item_weekly = {
         { loot_1 = { quest_id = 66377, item_id = 193900, loot_source = "Treasures", name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } },
         { loot_2 = { quest_id = 66378, item_id = 193901, loot_source = "Treasures", name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } },
         { loot_70514 = { quest_id = 70514, name = GetNameFromQuestID, info = "Primordial Aether - Arcane Enemies (i.e. Academy)" } },
         { loot_4 = { quest_id = 70515, item_id = 198968, loot_source = "Primalists (and Druids of Flame?)", name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } },
         -- { treatise =   { quest_id = 74115, name = GetNameFromQuestID, info = "Treatise" } }, -- {name="Stupidly Effective Stitchery - Gnoll Enemies (Tailoring)", quests={70525}, optionKey="tailoring", skillID=197},
      },
      factions_weekly = {
         { fireshards = { quest_id = 75150 } },
      },
      -- a_env.objectives.profession_enchanting.niffen_relic = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75865, profession = Enum.Profession.Enchanting } })
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


local function BuildObjectivesProfessions()
   local orderer_profession_enums = {}
   for key in pairs(source_data) do orderer_profession_enums[#orderer_profession_enums + 1] = key end
   table.sort(orderer_profession_enums)

   for _, profession_enum in ipairs(orderer_profession_enums) do
      local profession_data = source_data[profession_enum]
      for template_idx, template_key, template_data in array_of_pairs_iter(templates) do
         if profession_data[template_key] then
            for objective_idx, objective_key, objective_data in array_of_pairs_iter(profession_data[template_key]) do
               local merged_data = table_merge_shallow_left({ template_data, { profession = profession_enum }, objective_data })
               local objective_id = table.concat({ "profession", profession_enum, template_key, objective_key }, ",")
               merged_data.debug_id = objective_id
               profession_data[template_key][objective_idx][objective_key] = merged_data
               a_env.objectives[objective_id] = merged_data
            end
      end
   end
end
end
BuildObjectivesProfessions()

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
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
a_env.GetProfessionName = GetProfessionName

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
   { item_gather_weekly = table_merge_shallow_left({ weekly_profession_quest_template, { name = GetObjectiveProfessionLootName } }) },
   { item_weekly       = table_merge_shallow_left({ weekly_profession_quest_template, { name = GetObjectiveProfessionLootName, state = GetObjectiveProfessionLootProgress } }) },
   { valdrakken_orders = weekly_profession_quest_template },
   { darkmoon_faire    = table_merge_shallow_left({ weekly_profession_quest_template, { period = "event" } }) },
}

local source_data = {
   [Enum.Profession.Mining] = {
      valdrakken_weekly = {
         { draconium = { quest_id = 70617 } },
         { serevite = { quest_id = 70618 } },
         { rousing_fire = { quest_id = 72156 } },
         { earth = { quest_id = 72157 } },
      },
      item_gather_weekly = {
         { loot_1 = { quest_id = 72160, item_id = 201300, loot_source = "Nodes" } },
         { loot_2 = { quest_id = 72161, item_id = 201300, loot_source = "Nodes" } },
         { loot_3 = { quest_id = 72162, item_id = 201300, loot_source = "Nodes" } },
         { loot_4 = { quest_id = 72163, item_id = 201300, loot_source = "Nodes" } },
         { loot_5 = { quest_id = 72164, item_id = 201300, loot_source = "Nodes" } },
         { loot_6 = { quest_id = 72165, item_id = 201301, loot_source = "Nodes" } },
      },
      item_weekly = {
         { treatise = { quest_id = 74106, item_id = 194708, loot_source = "Scribe", if_completed_ignore_inbags = true } },
      },
      darkmoon_faire = { { only_one = {  quest_id = 29518 } } },
   },
   [Enum.Profession.Herbalism] = {
      valdrakken_weekly = {
         { writhebark = { quest_id = 70613 } },
         { bubble = { quest_id = 70614 } },
         { saxifrage = { quest_id = 70615 } },
         { hochenblume = { quest_id = 70616 } },
      },
      item_gather_weekly = {
         { loot_1 = { quest_id = 71857, item_id = 200677, loot_source = "Nodes" } },
         { loot_2 = { quest_id = 71858, item_id = 200677, loot_source = "Nodes" } },
         { loot_3 = { quest_id = 71859, item_id = 200677, loot_source = "Nodes" } },
         { loot_4 = { quest_id = 71860, item_id = 200677, loot_source = "Nodes" } },
         { loot_5 = { quest_id = 71861, item_id = 200677, loot_source = "Nodes" } },
         { loot_6 = { quest_id = 71864, item_id = 200678, loot_source = "Nodes" } },
      },
      item_weekly = {
         { treatise = { quest_id = 74107, item_id = 194704, loot_source = "Scribe", if_completed_ignore_inbags = true } },
      },
      darkmoon_faire = { { only_one = {  quest_id = 29514 } } },
   },
   [Enum.Profession.Skinning] = {
      valdrakken_weekly = {
         { resilient_leather = { quest_id = 70619 } },
         { dense_hide = { quest_id = 72158 } },
         { lustrous_scaled_hides = { quest_id = 72159 } },
      },
      item_gather_weekly = {
         { loot_1 = { quest_id = 70381, item_id = 198837, loot_source = "Gather" } },
         { loot_2 = { quest_id = 70383, item_id = 198837, loot_source = "Gather" } },
         { loot_3 = { quest_id = 70384, item_id = 198837, loot_source = "Gather" } },
         { loot_4 = { quest_id = 70385, item_id = 198837, loot_source = "Gather" } },
         { loot_5 = { quest_id = 70386, item_id = 198837, loot_source = "Gather" } },
         { loot_6 = { quest_id = 70389, item_id = 198841, loot_source = "Gather" } },
      },
      item_weekly = {
         { treatise = { quest_id = 74114, item_id = 201023, loot_source = "Scribe", if_completed_ignore_inbags = true } },
      },
      darkmoon_faire = { { only_one = {  quest_id = 29519 } } },
   },
   [Enum.Profession.Leatherworking] = {
      valdrakken_weekly = {
         { bonewrought_crossbow = { quest_id = 70567 } },
         { trailblazers_bracers = { quest_id = 70568 } },
         { herbalist_basket = { quest_id = 70569 } },
         { drums = { quest_id = 70571 } },
      },
      valdrakken_orders = { { only_one = { quest_id = 70594 } } },
      factions_weekly = {
         { niffen_mycelium = { quest_id = 75354 } },
         { niffen_rock_vipers = { quest_id = 75368 } },
         { dream_fibrous_thread = { quest_id = 77946, progress = a_env.GetObjectiveLargestIncompleteObjectiveProgressString } },
      },
      item_weekly = {
         { loot_1 = { quest_id = 66384, item_id = 193910, loot_source = "Treasures" } },
         { loot_2 = { quest_id = 66385, item_id = 193913, loot_source = "Treasures" } },
         { loot_3 = { quest_id = 70522, item_id = 198975, loot_source = "Proto-dragons" } },
         { loot_4 = { quest_id = 70523, item_id = 198976, loot_source = "Slyvern/Vorquin" } },
         { treatise = { quest_id = 74113, item_id = 194700, loot_source = "Scribe", if_completed_ignore_inbags = true } },
      },
      valdrakken_orders = { { only_one = {  quest_id = 70594 } } },
      darkmoon_faire = { { only_one = {  quest_id = 29517 } } },
   },
   [Enum.Profession.Alchemy] = {
      valdrakken_weekly = {
         { reclaim = { quest_id = 70530 } },
         { mana_potion = { quest_id = 70531 } },
         { healing_potion = { quest_id = 70532 } },
         { writhefire_oil = { quest_id = 70533 } },
      },
      factions_weekly = {
         { valdrakken_decay = { quest_id = 66937 } },
         { maruuk_gorloc_mucus = { quest_id = 66940 } },
         { maruuk_lashers = { quest_id = 72427 } },
         { niffen_deepflayers = { quest_id = 75363 } },
         { niffen_fungi = { quest_id = 75371 } },
         { dream_metamorphic_soot = { quest_id = 77932 } },
         { dream_bubbles = { quest_id = 77933 } },
      },
      item_weekly = {
         { loot_1 = { quest_id = 66373, item_id = 193891, loot_source = "Treasures" } },
         { loot_2 = { quest_id = 66374, item_id = 193897, loot_source = "Treasures" } },
         { loot_3 = { quest_id = 70504, item_id = 198963, loot_source = "Rousing Decay" } },
         { loot_4 = { quest_id = 70511, item_id = 198964, loot_source = "Elementals" } },
         { treatise = { quest_id = 74108, item_id = 194697, loot_source = "Scribe", if_completed_ignore_inbags = true } },
      },
      darkmoon_faire = { { only_one = {  quest_id = 29506 } } },
   },
   [Enum.Profession.Tailoring] = {
      valdrakken_weekly = {
         { surveyor_robe = { quest_id = 70572 } },
         { wildercloth_bolt = { quest_id = 70582 } },
         { chef_hat = { quest_id = 70586 } },
         { simple_reagent_bag = { quest_id = 70587 } },
      },
      factions_weekly = {
         { dragonscale_tarantula_legs = { quest_id = 66899 } },
         { valdrakken_gnoll_cloth = { quest_id = 66952 } },
         { valdrakken_fluffy = { quest_id = 66953 } },
         { dragonscale_scythid_pincers = { quest_id = 72410 } },
         { niffen_cocoon = { quest_id = 75407 } },
         { niffen_silk = { quest_id = 75600 } },
         { dream_primalist_garb = { quest_id = 77947 } },
         { dream_feathers = { quest_id = 77949, progress = a_env.GetObjectiveLargestIncompleteObjectiveProgressString } },
      },
      item_weekly = {
         { loot_66386 = { quest_id = 66386, item_id = 193898, loot_source = "Treasures" } },
         { loot_66387 = { quest_id = 66387, item_id = 193899, loot_source = "Treasures" } },
         { loot_3 = { quest_id = 70524, item_id = 198977, loot_source = "Nokhud" } },
         { loot_4 = { quest_id = 70525, item_id = 198978, loot_source = "Gnolls" } },
         { treatise = { quest_id = 74115, item_id = 194698, loot_source = "Scribe", if_completed_ignore_inbags = true } },
      },
      valdrakken_orders = { { only_one = {  quest_id = 70595 } } },
      darkmoon_faire = { { only_one = {  quest_id = 29520 } } },
   },
   [Enum.Profession.Inscription] = {
      valdrakken_weekly = {
         { spell_shield = { quest_id = 70558 } },
         { fastened_quill = { quest_id = 70559 } },
         { explorer_compendium = { quest_id = 70560 } },
         { blazing_ink = { quest_id = 70561 } },
      },
      factions_weekly = {
         { valdrakken_bark_parchment = { quest_id = 66943 } },
         { dragonscale_peacock = { quest_id = 66944 } },
         { valdrakken_icy_ink = { quest_id = 66945 } },
         { valdrakken_tarasek = { quest_id = 72438 } },
         { niffen_proclamation = { quest_id = 75573 } },
         { dream_fiery_essence = { quest_id = 77889 } },
         { dream_burning_runes = { quest_id = 77914, progress = a_env.GetObjectiveLargestIncompleteObjectiveProgressString } },
      },
      item_weekly = {
         { loot_1 = { quest_id = 66375, item_id = 193904, loot_source = "Treasures" } },
         { loot_2 = { quest_id = 66376, item_id = 193905, loot_source = "Treasures" } },
         { loot_70518 = { quest_id = 70518, item_id = 198971, loot_source = "Djaradin" } },
         { loot_70519 = { quest_id = 70519, item_id = 198972, loot_source = "Dragonkin/Drachtyr/Tarasek" } },
         { treatise = { quest_id = 74105, item_id = 194699, loot_source = "Scribe", if_completed_ignore_inbags = true } },
      },
      valdrakken_orders = { { only_one = { quest_id = 70592 } } },
      darkmoon_faire = { { only_one = {  quest_id = 29515 } } },
      -- niffen_proclamation = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75573, profession = Enum.Profession.Inscription } })
    -- {name="Valdrakken Profession Quests (Inscription)", quests={66943, 66944, 70559, 70561, 70558, 70560, 66945, 72438}, optionKey="inscription", skillID=773, useWorldState=true},
    -- {name="Crafting Order Quest (Inscription)", quests={70592}, optionKey="inscription", skillID=773},
   },
   [Enum.Profession.Jewelcrafting] = {
      valdrakken_weekly = {
         { crumbled_stone = { quest_id = 70562 } },
         { exhibition = { quest_id = 70563 } },
         { onyx_loupe = { quest_id = 70564 } },
         { pendant = { quest_id = 70565 } },
      },
      factions_weekly = {
         { dragonscale_djaradin = { quest_id = 66516 } },
         { iskaara_giant_core = { quest_id = 66950 } },
         { dragonscale_hornswog = { quest_id = 72428 } },
         { niffen_living_chips = { quest_id = 75602 } },
         { dream_pearls = { quest_id = 77892, progress = a_env.GetObjectiveLargestIncompleteObjectiveProgressString } },
         { dream_zaqali_adornments = { quest_id = 77912 } },
      },
      valdrakken_orders = { { only_one = {  quest_id = 70593 } } },
      item_weekly = {
         { loot_1 = { quest_id = 66388, item_id = 193909, loot_source = "Treasures" } },
         { loot_2 = { quest_id = 66389, item_id = 193907, loot_source = "Treasures" } },
         { loot_3 = { quest_id = 70520, item_id = 198973, loot_source = "Elementals" } },
         { loot_4 = { quest_id = 70521, item_id = 198974, loot_source = "Nokhud/Sundered Flame" } },
         { treatise = { quest_id = 74112, item_id = 194703, loot_source = "Scribe", if_completed_ignore_inbags = true } },
      },
      darkmoon_faire = { { only_one = {  quest_id = 29516 } } },
      -- niffen_proclamation = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75573, profession = Enum.Profession.Inscription } })
      -- a_env.objectives.profession_jewelcrafting.niffen_whelkshell = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75362, profession = Enum.Profession.Jewelcrafting } })
      -- {name="Draconic Treatise (Jewelcrafting)", quests={74112}, optionKey="jewelcrafting", skillID=755},
      -- {name="Valdrakken Profession Quests (Jewelcrafting)", quests={66516, 70565, 66950, 66949, 72428, 70564, 70563, 70562}, optionKey="jewelcrafting", skillID=755, useWorldState=true},
      -- {name="Crafting Order Quest (Jewelcrafting)", quests={70593}, optionKey="jewelcrafting", skillID=755},
   },
   [Enum.Profession.Blacksmithing] = {
      valdrakken_weekly = {
         { explorer_boots = { quest_id = 70211 } },
         { draconium_axe = { quest_id = 70233 } },
         { draconium_hammer = { quest_id = 70234 } },
         { repair_hammer = { quest_id = 70235 } },
      },
      factions_weekly = {
         { maruuk_weapons = { quest_id = 66517 } },
         { maruuk_magma_core = { quest_id = 66897 } },
         { maruuk_djaradin_tools = { quest_id = 66941 } },
         { maruuk_eathen_samples = { quest_id = 72398 } },
         { lava_blades = { quest_id = 75148 } },
         { dream_draconium_sword = { quest_id = 77935 } }, -- !!!TODO!!! set craft name for this quest
         { dream_endless_flame = { quest_id = 77936 } },
      -- a_env.objectives.profession_blacksmithing.niffen_plate = table_merge_shallow_left({ weekly_profession_quest_template, { quest_id = 75569, profession = Enum.Profession.Blacksmithing } })
      },
      item_weekly = {
         { loot_1 = { quest_id = 66381, item_id = 192131, loot_source = "Treasures" } },
         { loot_2 = { quest_id = 66382, item_id = 192132, loot_source = "Treasures" } },
         { loot_3 = { quest_id = 70512, item_id = 198965, loot_source = "Rousing Earth" } },
         { loot_4 = { quest_id = 70513, item_id = 198966, loot_source = "Rousing Fire" } },
         { treatise = { quest_id = 74109, item_id = 198454, loot_source = "Scribe", if_completed_ignore_inbags = true } },
      },
      valdrakken_orders = { { only_one = {  quest_id = 70589 } } },
      darkmoon_faire = { { only_one = {  quest_id = 29508 } } },
   },
   [Enum.Profession.Enchanting] = {
      valdrakken_weekly = {
         { runed_rod = { quest_id = 72155 } },
         { chromatic_dust = { quest_id = 72172 } },
         { bracer_leech = { quest_id = 72173 } },
         { scepters = { quest_id = 72175 } },
      },
      factions_weekly = {
         { iskaara_djaradin_fireproof = { quest_id = 66884 } },
         { iskaara_gnoll_relics = { quest_id = 66900 } },
         { dragonscale_crystal_quill = { quest_id = 66935 } },
         { iskaara_tempest_armaments = { quest_id = 72423 } },
         { fireshards = { quest_id = 75150 } },
         { niffen_relic = { quest_id = 75865 } },
         { dream_enchanted_shrubs = { quest_id = 77910, progress = a_env.GetObjectiveLargestIncompleteObjectiveProgressString } },
         { dream_glowdrop_sugar = { quest_id = 77937 } },
      },
      item_weekly = {
         { loot_1 = { quest_id = 66377, item_id = 193900, loot_source = "Treasures" } },
         { loot_2 = { quest_id = 66378, item_id = 193901, loot_source = "Treasures" } },
         { loot_3 = { quest_id = 70514, item_id = 198967, loot_source = "Arcane" } },
         { loot_4 = { quest_id = 70515, item_id = 198968, loot_source = "Primalists (and Druids of Flame?)" } },
         { treatise = { quest_id = 74110, item_id = 194702, loot_source = "Treatise", if_completed_ignore_inbags = true } },
      },
      darkmoon_faire = { { only_one = {  quest_id = 29510 } } },
   },
   [Enum.Profession.Engineering] = {
      valdrakken_weekly = {
         { leather_goggles = { quest_id = 70539 } },
         { samophlange = { quest_id = 70540 } },
         { serevite_bolts = { quest_id = 70545 } },
         { bronze_fireflight = { quest_id = 70557 } },
      },
      factions_weekly = {
         { valdrakken_stolen_tools = { quest_id = 66890 } },
         { dragonscale_phoenix_ash = { quest_id = 66891 } },
         { dream_beacons = { quest_id = 77891, progress = a_env.GetObjectiveLargestIncompleteObjectiveProgressString } },
         { dream_morel = { quest_id = 77938, progress = a_env.GetObjectiveLargestIncompleteObjectiveProgressString } },
      },
      item_weekly = {
         { loot_1 = { quest_id = 66379, item_id = 193902, loot_source = "Treasures" } },
         { loot_2 = { quest_id = 66380, item_id = 193903, loot_source = "Treasures" } },
         { loot_3 = { quest_id = 70516, item_id = 198969, loot_source = "Titan" } },
         { loot_4 = { quest_id = 70517, item_id = 198970, loot_source = "Dragonkin/Tarasek" } },
         { treatise = { quest_id = 74111, item_id = 198510, loot_source = "Treatise", if_completed_ignore_inbags = true } },
      },
      valdrakken_orders = { { only_one = {  quest_id = 70591 } } },
      darkmoon_faire = { { only_one = {  quest_id = 29511 } } },
   },
}

local one_quest_per_group_weeklies = {
   { valdrakken_weekly = "Valdrakken" },
   { loamm_weekly = "Loamm" },
}
local orderer_profession_enums = {}
for key in pairs(source_data) do orderer_profession_enums[#orderer_profession_enums + 1] = key end
table.sort(orderer_profession_enums)

a_env.objectives.profession.source_data = source_data
a_env.objectives.profession.orderer_profession_enums = orderer_profession_enums

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

local output_table_postprocess = {
   valdrakken_weekly  = function(output_table) output_table.group_suffix = "Valdrakken" OneActiveProfessionQuestGroup(output_table) end,
   factions_weekly    = function(output_table) output_table.group_suffix = "Factions" OneActiveProfessionQuestGroup(output_table) end,
   item_gather_weekly = function(output_table)
      local group_name = output_table.profession_name .. " Gather"
      CombineGatherQuestGroup(output_table)
      output_table[1].info = group_name
   end,
   item_weekly        = function(output_table)
      local group_name = output_table.profession_name .. " Items"
      for idx = 1, #output_table do output_table[idx].info = group_name end
   end,
   valdrakken_orders  = function(output_table) output_table.group_suffix = "Orders" OneActiveProfessionQuestGroup(output_table) end,
   darkmoon_faire     = function(output_table) if output_table[1] then output_table[1].info = output_table.profession_name .. " Darkmoon Faire" end end,
}
a_env.objectives.profession.output_table_postprocess = output_table_postprocess

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
local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals

a_env.objectives.event_hallowsend = a_env.objectives.event_hallowsend or {}

-- /outfit v1 77344,91125,0,77345,47211,0,83203,22041,94331,83055,198608,224968,219201,-1,0,220502,0


local completed_account_mark = a_env.state_colors["completed"]:WrapTextInColorCode('*')

function a_env.LGO_StateMarkAccountCompleted(objective)
   local state = a_env.GetLazy(objective, a_env.GetObjectiveStateDefault)
   if state == "completed" then return "ok", state end

   local completed_account = a_env.GetLazy(objective, "completed_account")
   if completed_account then state = state .. completed_account_mark end

   return "ok", state
end

local header = { name = "Midsummer", header = true }
local header_loot = { name = "Midsummer Loot", header = true }

local dungeon = {
   { ahune = table_merge_shallow_left({ a_env.event_dungeon_objective_template, { lfg_dungeon_id = 286 } }) },
}

local IsTooltipDataAlreadyKnown = LibStub("LibTTScan-1.0").IsTooltipDataAlreadyKnown
local function LGO_Completed_ItemMustBeKnownByLibTTScan(objective)
   local item_id = objective.item_id
   -- print("LGO_Completed_ItemMustBeKnownByLibTTScan", item_id)

   if PlayerHasToy(item_id) then return "cachenonnil", "PlayerHasToy" end

   local name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradeable, unique, obtainable, displayID, speciesID = C_PetJournal.GetPetInfoByItemID(item_id)
   if speciesID then
      local collected, max_collected = C_PetJournal.GetNumCollectedInfo(speciesID)
      if collected and collected > 0 then return "cachenonnil", "C_PetJournal.GetPetInfoByItemID/GetNumCollectedInfo" end
   end

   local tooltip_data = C_TooltipInfo.GetItemByID(item_id)
   local known = IsTooltipDataAlreadyKnown(tooltip_data)
   -- You can unlearn items, but we ignore that possibility for our purposes
   if known then return "cachenonnil", "LibTTScan.IsTooltipDataAlreadyKnown" end
end

local CIMI_Known = _G['SR13-Utils'].CIMI_Known
local function LGO_Completed_ItemMustBeKnownByCIMI(objective)
   local item_id = objective.item_id
   local known = CIMI_Known('item:' .. item_id)
   if known then return "cachenonnil", "CIMI_Known" end
end

local function LGO_State_ItemMustBeKnown(objective)
   local completed = a_env.GetLazy(objective, "completed")
   -- You can unlearn items, but we ignore that possibility for our purposes
   if completed then return "cachenonnil", "completed" end

   local item_id = objective.item_id
   local count = GetItemCount(item_id)
   if count == 0 then
      local includeBank = true
      local w_bank_count = GetItemCount(item_id, includeBank)
      if w_bank_count > 0 then
         return "ok", "itemmissinginbank"
      end
   else
      return "ok", "inbags"
   end

   return "ok", "notpickedup"
end

a_env.template_item_known_by_libttscan = {
   name = a_env.GetObjectiveItemName,
   completed = LGO_Completed_ItemMustBeKnownByLibTTScan,
   state = LGO_State_ItemMustBeKnown,
   available = a_env.LGO_Available_MustBeCompletedOnce,
}

local template = table_merge_shallow_left({ a_env.template_item_known_by_libttscan, { info = "first per account", period = a_env.event_dungeon_objective_template.period } })
local dungeon_account_daily_first = {
   { staff_rethfuras = table_merge_shallow_left({ template, { item_id = 246570 } }) },
   { pole_rethfuras  = table_merge_shallow_left({ template, { item_id = 244423 } }) },
   { staff_glazfuris = table_merge_shallow_left({ template, { item_id = 246571 } }) },
   { pole_glazfuris  = table_merge_shallow_left({ template, { item_id = 244422 } }) },
   { crown_frost     = table_merge_shallow_left({ template, { item_id = 244356 } }) },
   { wylderdrake     = table_merge_shallow_left({ template, { item_id = 224163 } }) },
}

local template = table_merge_shallow_left({ a_env.template_item_known_by_libttscan, { info = "first per character", period = a_env.event_dungeon_objective_template.period } })
local dungeon_character_daily_first = {
   -- https://www.wowhead.com/item=35498/formula-enchant-weapon-deathfrost
   { illusion_deathfrost = table_merge_shallow_left({ template, { item_id = 138838 } }) },
   { frostscythe         = table_merge_shallow_left({ template, { item_id = 117373, completed = LGO_Completed_ItemMustBeKnownByCIMI } }) },
   -- https://www.wowhead.com/item=53641/ice-chip
   -- https://www.wowhead.com/item=117376/the-frost-lords-battle-shroud?bonus=5472
   -- https://www.wowhead.com/item=117375/shroud-of-winters-chill?bonus=5472
   -- https://www.wowhead.com/item=117372/cloak-of-the-frigid-winds?bonus=5472
}

local template = table_merge_shallow_left({ a_env.template_item_known_by_libttscan, { info = "repeatable", period = "dungeon" } })
local dungeon_repeatable = {
   { icebound_cloak = table_merge_shallow_left({ template, { item_id = 117374, completed = LGO_Completed_ItemMustBeKnownByCIMI } }) },
   { war_cloak      = table_merge_shallow_left({ template, { item_id = 117377, completed = LGO_Completed_ItemMustBeKnownByCIMI } }) },
}
local dungeon_once = {
   --[[
https://www.wowhead.com/item=35279/tabard-of-summer-skies
https://www.wowhead.com/item=35280/tabard-of-summer-flames
   ]]
}
local template = table_merge_shallow_left({ a_env.template_item_known_by_libttscan, { info = "vendor", period = "event" } })
local vendors = {
    { grand_mantle = table_merge_shallow_left({ template, { item_id = 242741 } }) },
    { grand_helm = table_merge_shallow_left({ template, { item_id = 242740 } }) },
    { grand_belt = table_merge_shallow_left({ template, { item_id = 242742 } }) },
    { midsummer_safeguard = table_merge_shallow_left({ template, { item_id = 220785 } }) },
    { mantle_of_midsummer = table_merge_shallow_left({ template, { item_id = 220787 } }) },
    { summer_cranial_skillet = table_merge_shallow_left({ template, { item_id = 188695 } }) },
    { helm_of_tff = table_merge_shallow_left({ template, { item_id = 74278 } }) },
    { mantle_of_tff = table_merge_shallow_left({ template, { item_id = 23324, completed = LGO_Completed_ItemMustBeKnownByCIMI } }) },
    { vestment_of_summer = table_merge_shallow_left({ template, { item_id = 34685, completed = LGO_Completed_ItemMustBeKnownByCIMI } }) },
    { batons = table_merge_shallow_left({ template, { item_id = 188701 } }) },
    { sandals_of_summer = table_merge_shallow_left({ template, { item_id = 34683, completed = LGO_Completed_ItemMustBeKnownByCIMI } }) },
    { insulated_dancing_insoles = table_merge_shallow_left({ template, { item_id = 188699 } }) },
    { cozy_bonfire = table_merge_shallow_left({ template, { item_id = 116435 } }) },
    { blazing_cindercrawler = table_merge_shallow_left({ template, { item_id = 116439 } }) },
    { burning_defenders_medallion = table_merge_shallow_left({ template, { item_id = 116440 } }) },
    { brazier_of_dancing_flames = table_merge_shallow_left({ template, { item_id = 34686 } }) },
    { captured_flame = table_merge_shallow_left({ template, { item_id = 23083 } }) },
    { set_of_matches = table_merge_shallow_left({ template, { item_id = 141649 } }) },
    { flamin_ring = table_merge_shallow_left({ template, { item_id = 206038 } }) },
    { igneous_flameling = table_merge_shallow_left({ template, { item_id = 141714 } }) },
    { fire_eaters_hearthstone = table_merge_shallow_left({ template, { item_id = 166746 } }) },
--[[
"|cnIQ3:|Hitem:242741::::::::70:63::14::1:28:394:::::|h[Grand Mantle of the Fire Festival]|h|r",
"|cnIQ3:|Hitem:242740::::::::70:63::14::1:28:394:::::|h[Grand Helm of the Fire Festival]|h|r",
"|cnIQ3:|Hitem:242742::::::::70:63::14::1:28:394:::::|h[Grand Belt of the Fire Festival]|h|r",
"|cnIQ3:|Hitem:220785::::::::70:63::14::1:28:394:::::|h[Midsummer Safeguard]|h|r",
"|cnIQ3:|Hitem:220787::::::::70:63::14::1:28:394:::::|h[Mantle of Midsummer]|h|r",
"|cnIQ2:|Hitem:188695::::::::70:63::14::1:28:394:::::|h[Summer Cranial Skillet]|h|r",
"|cnIQ2:|Hitem:74278::::::::70:63::14::1:28:394:::::|h[Helm of the Fire Festival]|h|r",
"|cnIQ2:|Hitem:23324::::::::70:63::14::1:28:394:::::|h[Mantle of the Fire Festival]|h|r",
"|cnIQ2:|Hitem:34685::::::::70:63::14::1:28:394:::::|h[Vestment of Summer]|h|r",
"|cnIQ2:|Hitem:188701::::::::70:63::14::1:28:394:::::|h[Fire Festival Batons]|h|r",
"|cnIQ2:|Hitem:34683::::::::70:63::14::1:28:394:::::|h[Sandals of Summer]|h|r",
"|cnIQ2:|Hitem:188699::::::::70:63::14::1:28:394:::::|h[Insulated Dancing Insoles]|h|r",
"|cnIQ3:|Hitem:116435::::::::70:63::14::1:28:394:::::|h[Cozy Bonfire]|h|r",
"|cnIQ2:|Hitem:116439::::::::70:63::14::1:28:373:::::|h[Blazing Cindercrawler]|h|r",
"|cnIQ3:|Hitem:116440::::::::70:63::14::1:28:394:::::|h[Burning Defender's Medallion]|h|r",
"|cnIQ3:|Hitem:34686::::::::70:63::14::1:28:394:::::|h[Brazier of Dancing Flames]|h|r",
"|cnIQ2:|Hitem:23083::::::::70:63::14::1:28:373:::::|h[Captured Flame]|h|r",
"|cnIQ3:|Hitem:141649::::::::70:63::14::1:28:394:::::|h[Set of Matches]|h|r",
"|cnIQ3:|Hitem:206038::::::::70:63::14::1:28:394:::::|h[Flamin' Ring of Flashiness]|h|r",
"|cnIQ3:|Hitem:141714::::::::70:63::14::1:28:373:::::|h[Igneous Flameling]|h|r",
"|cnIQ3:|Hitem:166746::::::::70:63::14::1:28:394:::::|h[Fire Eater's Hearthstone]|h|r",
]]
}

local dailies = {
   { first_loot           = table_merge_shallow_left({ a_env.daily_quest_template, { item_id = 117394, quest_id = 83134, info = "first per account", name = a_env.GetObjectiveItemName } }) },
   { strike_ashenvale     = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 11917, info = C_Map.GetAreaInfo(331) } }) },
   { strike_desolace      = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 11947, info = C_Map.GetAreaInfo(405) } }) },
   { strike_silithus      = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 11953, info = C_Map.GetAreaInfo(1377) } }) },
   { strike_stranglethorn = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 11948, info = C_Map.GetAreaInfo(5339) } }) },
   { strike_searing       = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 11952, info = C_Map.GetAreaInfo(51) } }) },
   { strike_hellfire      = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 11954, info = C_Map.GetAreaInfo(3483) } }) },
   { torch_tossing        = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 82109 } }) },
}

-- /dump LibStub("LibTTScan-1.0").IsTooltipDataAlreadyKnown(C_TooltipInfo.GetItemByID(246570))
-- /run print(GetItemInfo(246570))

function a_env.OutputTablesMidsummer()
   local output_tables = {}
   local output_table
   local idx = 0

   idx = idx + 1 output_tables[idx] = a_env.CalculateObjectivesToOutputTable(dungeon, "array_of_pairs")
   header.info = ("tokens: %d"):format(GetItemCount(23247, true, true, true))
   output_tables[idx].header = header
   idx = idx + 1 output_tables[idx] = a_env.CalculateObjectivesToOutputTable(dailies, "array_of_pairs")

   idx = idx + 1 output_tables[idx] = a_env.CalculateObjectivesToOutputTable(dungeon_account_daily_first, "array_of_pairs")
   output_tables[idx].header = header_loot
   idx = idx + 1 output_tables[idx] = a_env.CalculateObjectivesToOutputTable(dungeon_character_daily_first, "array_of_pairs")
   idx = idx + 1 output_tables[idx] = a_env.CalculateObjectivesToOutputTable(dungeon_repeatable, "array_of_pairs")
   -- idx = idx + 1 output_tables[idx] = a_env.CalculateObjectivesToOutputTable(dungeon_once, "array_of_pairs")
   idx = idx + 1 output_tables[idx] = a_env.CalculateObjectivesToOutputTable(vendors, "array_of_pairs")

   -- Sell soulbound already known: |cnIQ4:|Hitem:183052::::::::70:257:::::::::|h[Darkwarren Hardshell]|h|r

   return output_tables
end

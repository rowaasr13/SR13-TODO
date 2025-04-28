local a_name, a_env = ...

-- [AUTOLOCAL START]
local _G = _G
-- [AUTOLOCAL END]

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals
local array_of_pairs_iter = _G["SR13-Lib"].pair_utils.array_of_pairs_iter

-- Objective is only "available" (i.e. shown at all) if item is MISSING. count == 0 means available = true.
local function GetObjectiveItemMustExistsAvailable(objective)
   if not objective.item_id then return "cachenonnil", "<NOT SET>" end
   local count = GetItemCount(objective.item_id, false, false, false)
   -- print("GetObjectiveItemMustExistsAvailable", objective.item_id, count)
   return "ok", count == 0
end

-- Objective is only "available" (i.e. shown at all) if item EXISTS. count > 0 means available = true. Serves as both available and progress tracker.
local function GetObjectiveItemMustBeRemovedCount(objective)
   if not objective.item_id then return "cachenonnil", "<NOT SET>" end
   local completed
   if objective.quest_id_completed then -- this quest must be completed for item to be considered no longer useful
      if C_QuestLog.IsQuestFlaggedCompleted(objective.quest_id_completed) then completed = true end
   end
   local count = GetItemCount(objective.item_id, true, true, true)
   -- print("GetObjectiveItemMustExistsAvailable", objective.item_id, count)
   if count == 0 then count = false end
   if count and completed then return "ok", "completed" end
   return "ok", count
end

local function GetObjectiveItemNameWithHighlightByAura(objective)
   local name = a_env.GetLazy(objective, a_env.GetObjectiveItemName)
   if not name then return ok, name end

   if objective.name_highlight_aura_spell_id and C_UnitAuras.GetPlayerAuraBySpellID(objective.name_highlight_aura_spell_id) then
      name = GREEN_FONT_COLOR:WrapTextInColorCode(name)
   end

   return "ok", name
end

local template_item_must_exist = {
   name = a_env.GetObjectiveItemName,
   state = "itemmissing",
   available = GetObjectiveItemMustExistsAvailable,
}

local template_item_must_be_removed = {
   name = a_env.GetObjectiveItemName,
   state = "pickedup",
   progress = GetObjectiveItemMustBeRemovedCount,
   available = GetObjectiveItemMustBeRemovedCount,
}

a_env.objectives.items = a_env.objectives.items or {}

local items = {
   { expedition_shovel = table_merge_shallow_left({ template_item_must_exist, { item_id = 191304, info = "Blacksmithing / Dragonscale" } }) },
   { dig_map = table_merge_shallow_left({ template_item_must_be_removed, { item_id = 205982, info = "Loamm Niffen" } }) },
   { buried_collection = table_merge_shallow_left({ template_item_must_be_removed, { item_id = 205288, info = "Loamm Niffen" } }) },
   { dragonscale_turnin = table_merge_shallow_left({ template_item_must_be_removed, { item_id = 192055, info = "Dragonscale Expedition Basecamp", name_highlight_aura_spell_id = 430666 } }) },
   { valdrakken_turnin = table_merge_shallow_left({ template_item_must_be_removed, { item_id = 199906, info = "Valdrakken" } }) },
   { iskaara_turnin = table_merge_shallow_left({ template_item_must_be_removed, { item_id = 200071, info = "Iskaara", name_highlight_aura_spell_id = 430666 } }) },
   { iskaara_story1 = table_merge_shallow_left({ template_item_must_be_removed, { item_id = 201470, info = "Iskaara", name_highlight_aura_spell_id = 430666 } }) },
   { iskaara_story2 = table_merge_shallow_left({ template_item_must_be_removed, { item_id = 201471, info = "Iskaara", name_highlight_aura_spell_id = 430666 } }) },
   { iskaara_reach = table_merge_shallow_left({ template_item_must_be_removed, { item_id = 202854, info = "Forbidden Reach - Iskaara Tuskarr" } }) },
   { maruuk_reach = table_merge_shallow_left({ template_item_must_be_removed, { item_id = 202872, info = "Forbidden Reach - Maruuk Centaur" } }) },
   { reach_tailoring1 = table_merge_shallow_left({ template_item_must_be_removed, { item_id = 203406, info = "Forbidden Reach - Tailoring" } }) },
   { reach_cooking2 = table_merge_shallow_left({ template_item_must_be_removed, { item_id = 203409, info = "Forbidden Reach - Cooking" } }) },
   { ancient_vault_artifact = table_merge_shallow_left({ template_item_must_be_removed, { item_id = 201411, info = "Dragonscale Expedition @Valdrakken", name_highlight_aura_spell_id = 430666 } }) },
}
for idx, key, val in array_of_pairs_iter(items) do
   if val.name_highlight_aura_spell_id then val.name = GetObjectiveItemNameWithHighlightByAura end
end

function a_env.OutputTableItems()
   local output_table = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(items))
   local any_available
   for idx = 1, #output_table do
      if output_table[idx].available then any_available = true break end
   end
   if not any_available then return {} end
   output_table.header = { name = "Items", header = true }
   return output_table
end

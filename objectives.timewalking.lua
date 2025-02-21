local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local table_add_pairs = _G["SR13-Lib"].pair_utils.table_add_pairs
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals
local array_of_pairs_iter = _G["SR13-Lib"].pair_utils.array_of_pairs_iter

local function GetObjectiveTimewalkingDungeonAvailable(objective)
   local joinable = IsLFGDungeonJoinable(objective.lfg_dungeon_id)
   if joinable then return "ok", "IsLFGDungeonJoinable" end
   if C_UnitAuras.GetPlayerAuraBySpellID(objective.aura_spell_id) then return "ok", "GetPlayerAuraBySpellID" end
end

local function GetObjectiveTimewalkingTurnInAvailable(objective)
   local includeBank = true
   local count = C_Item.GetItemCount(objective.quest_start_item_id, includeBank)
   if count and (count > 0) then return "ok", "GetItemCount" end
   return GetObjectiveTimewalkingDungeonAvailable(objective)
end

local timewalking_quest_template = table_merge_shallow_left({ a_env.weekly_quest_template, {
   name = a_env.GetObjectiveLFGRandomDungeonName,
   available = GetObjectiveTimewalkingDungeonAvailable,
   progress = a_env.GetObjectiveQuestSingleObjectiveProgressString,
} })

local timewalking_token_turnin_quest_template = table_merge_shallow_left({ a_env.weekly_quest_template, {
   available = GetObjectiveTimewalkingTurnInAvailable,
} })

local timewalking_raid_quest_template = table_merge_shallow_left({ a_env.weekly_quest_template, {
   available = GetObjectiveTimewalkingDungeonAvailable,
} })

local timewalking = {
   { classic         = { quest_id = { 85947 }, lfg_dungeon_id = 2634, aura_spell_id = 452307, item_turn_in_item_id = 225348, item_turn_in_quest_id = 83285 } },
   { burning_crusade = { quest_id = { 85948, 72727 }, lfg_dungeon_id =  744, aura_spell_id = 335148, item_turn_in_item_id = 129747, item_turn_in_quest_id = 40168 } },
   { lichking        = { quest_id = { 85949 }, lfg_dungeon_id =  995, aura_spell_id = 335149, item_turn_in_item_id = 129928, item_turn_in_quest_id = 40173 } },
   { cataclysm       = { quest_id = { 72810, 86556 }, lfg_dungeon_id = 1146, aura_spell_id = 335150, item_turn_in_item_id = 133377, item_turn_in_quest_id = 40786, raid_quest_id = 57637 } },
   { pandaria        = { quest_id = { 72725, 86560 }, lfg_dungeon_id = 1453, aura_spell_id = 335151, item_turn_in_item_id = 143776, item_turn_in_quest_id = 45563 } },
   { wod             = { quest_id = { 72724, 86563 }, lfg_dungeon_id = 1971, aura_spell_id = 335152, item_turn_in_item_id = 167922, item_turn_in_quest_id = 55499 } },
   { legion          = { quest_id = { 72719, 86564 }, lfg_dungeon_id = 2274, aura_spell_id = 359082, item_turn_in_item_id = 187611, item_turn_in_quest_id = 64710 } },
}

for idx, key, val in array_of_pairs_iter(timewalking) do
   local out = {}
   val.group_dungeon_quest = out
   for quest_id_idx = 1, #val.quest_id do
      out[#out + 1] = { ['dungeon_' .. quest_id_idx] = table_merge_shallow_left({ timewalking_quest_template, val, { quest_id = val.quest_id[quest_id_idx]} }) }
   end

   -- not a group, just a single-element array
   val.item_turn_in_quest = { table_merge_shallow_left({ timewalking_token_turnin_quest_template, val, { quest_id = val.item_turn_in_quest_id, quest_start_item_id = val.item_turn_in_item_id } }) }
   if val.raid_quest_id then
      val.raid_quest = { table_merge_shallow_left({ timewalking_raid_quest_template, val, { quest_id = val.raid_quest_id } }) }
   end
end

function a_env.OutputTablesTimewalking()
   local output_tables = {}
   local output_table

   for idx, key, val in array_of_pairs_iter(timewalking) do
      output_table = a_env.CalculateObjectivesToOutputTable(val.group_dungeon_quest, "array_of_pairs")
      output_table.none_active = { name = output_table[1].name, info = output_table[1].info, state = output_table[1].state, period = output_table[1].period }
      a_env.OutputTableLeaveOnlyActiveQuest(output_table)
      output_tables[#output_tables + 1] = output_table

      output_table = a_env.CalculateObjectivesToOutputTable(val.item_turn_in_quest)
      output_tables[#output_tables + 1] = output_table

      if val.raid_quest then
         output_table = a_env.CalculateObjectivesToOutputTable(val.raid_quest)
         output_tables[#output_tables + 1] = output_table
      end
   end

   return output_tables
end

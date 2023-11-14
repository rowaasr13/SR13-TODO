local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local table_add_pairs = _G["SR13-Lib"].pair_utils.table_add_pairs
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals
local array_of_pairs_iter = _G["SR13-Lib"].pair_utils.array_of_pairs_iter

local function GetObjectiveTimewalkingDungeonAvailable(self)
   local id, name, joinable = a_env.GetLFGRandomDungeonInfoByDungeonId(self.lfg_dungeon_id)
   if joinable then return "ok", "IsLFGDungeonJoinable" end
   if C_UnitAuras.GetPlayerAuraBySpellID(self.aura_spell_id) then return "ok", "GetPlayerAuraBySpellID" end
end


local timewalking_quest_template = table_merge_shallow_left({ a_env.weekly_quest_template, {
   name = a_env.GetObjectiveLFGRandomDungeonName,
   available = GetObjectiveTimewalkingDungeonAvailable,
   progress = a_env.GetObjectiveQuestSingleObjectiveProgressString,
} })

local timewalking_token_turnin_quest_template = table_merge_shallow_left({ a_env.weekly_quest_template, {
   available = GetObjectiveTimewalkingDungeonAvailable,
} })

-- a_env.objectives.weekly_sign.timewalking_cataclysm = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 72810, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } })
-- a_env.objectives.weekly_sign.timewalking_cataclysm_token = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 40786 } }) -- add: item in inventory, item in inventory+no event - throw away
-- a_env.objectives.weekly_sign.timewalking_burning_crusade = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 72727, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } })
-- a_env.objectives.weekly_sign.timewalking_burning_crusade_token = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 40168 } }) -- add: item in inventory, item in inventory+no event - throw away
-- local timewalking_legion = { quest_id = 72719, lfg_dungeon_id = 2274, aura_spell_id = 359082, item_turn_in_item_id = 187611, item_turn_in_quest_id = 64710 }
-- local timewalking_legion = { quest_id = 72719, lfg_dungeon_id = 2274, aura_spell_id = 359082, item_turn_in_item_id = 187611, item_turn_in_quest_id = 64710 }
-- a_env.objectives.weekly_sign.timewalking_legion = table_merge_shallow_left({timewalking_quest_template, timewalking_legion })

local timewalking = {
   { lichking = { quest_id = 72726, lfg_dungeon_id =  995, aura_spell_id = 335149, item_turn_in_item_id = 129928, item_turn_in_quest_id = 40173 } },
   { pandaria = { quest_id = 72725, lfg_dungeon_id = 1453, aura_spell_id = 335151, item_turn_in_item_id = 143776, item_turn_in_quest_id = 45563 } },
   { wod      = { quest_id = 72724, lfg_dungeon_id = 1971, aura_spell_id = 335152, item_turn_in_item_id = 167922, item_turn_in_quest_id = 55499 } },
   { legion   = { quest_id = 72719, lfg_dungeon_id = 2274, aura_spell_id = 359082, item_turn_in_item_id = 187611, item_turn_in_quest_id = 64710 } },
}

local branch = {}
a_env.objectives.weekly_sign.timewalking = branch

local timewalking_objectives = {}
local out = timewalking_objectives
for idx, key, val in array_of_pairs_iter(timewalking) do
   out[#out + 1] = { [key .. '_dungeon'] = table_merge_shallow_left({ timewalking_quest_template, val })  }
   out[#out + 1] = { [key .. '_item_turn_in'] = table_merge_shallow_left({ timewalking_token_turnin_quest_template, val, { quest_id = val.item_turn_in_quest_id} }) }
end

table_add_pairs(branch, timewalking_objectives)

function a_env.OutputTableTimewalking()
   local output_table = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(timewalking_objectives))

   return output_table
end

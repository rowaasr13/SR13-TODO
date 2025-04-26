local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local table_add_pairs = _G["SR13-Lib"].pair_utils.table_add_pairs
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals

local header = { name = _G.EXPANSION_NAME8, header = true }

local function GetObjectiveCovenantAvailable(objective)
   return "ok", C_Covenants.GetActiveCovenantID() == objective.covenant_id
end

local ordered = {
   { anima1000_kyrian    = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 61982, covenant_id = Enum.CovenantType.Kyrian,    available = GetObjectiveCovenantAvailable, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } }) },
   { anima1000_necrolord = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 61983, covenant_id = Enum.CovenantType.Necrolord, available = GetObjectiveCovenantAvailable, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } }) },
   { anima1000_nightfae  = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 61984, covenant_id = Enum.CovenantType.NightFae,  available = GetObjectiveCovenantAvailable, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } }) },
   { korthia = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 63949, faction_id = 2470, info = "Death's Advance @ Korthia", progress = a_env.GetObjectiveLargestIncompleteObjectiveProgressString } }) }, -- add unlock
   { zereth = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 66042, faction_id = 2478, info = "Enlgihtened @ Zereth Mortis", progress = a_env.GetObjectiveLargestIncompleteObjectiveProgressString } }) }, -- add unlock
   { s1_worldboss_mortanis = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 61816, info = C_Map.GetAreaInfo(11462) } }) },
   { s2_worldboss = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 64531, info = C_Map.GetAreaInfo(11400) } }) }, -- add unlock
   { s3_worldboss = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 65143, info = C_Map.GetAreaInfo(13536) } }) }, -- add unlock (only need portal?)
}

local empty = {}
local function OutputTables()
   if C_Covenants.GetActiveCovenantID() == Enum.CovenantType.None then return empty end

   local output_tables = {}
   local output_table

   output_tables[1] = a_env.CalculateObjectivesToOutputTable(ordered, "array_of_pairs")
   output_tables[1].header = header

   return output_tables
end

a_env.OutputTablesShadowlands = OutputTables

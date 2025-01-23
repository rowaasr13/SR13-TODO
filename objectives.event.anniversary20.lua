local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals

local anniversary20_header = { name = "Anniversary 20", header = true }
local anniversary20_ordered1 = {
   { greench = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 6983, info = "5w tokens", period = "daily" } }) },
   { fun = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 84616, info = "3w tokens", period = "daily" } }) },
   { timewalk = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 85947, info = "3w tokens", period = "weekly", progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } }) },
   { codex = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 82783, info = "3w tokens", period = "weekly" } }) },
   { honor = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 57300, info = "3w tokens", period = "weekly", progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } }) },
   { question = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 43461, period = "daily" } }) },
}

local anniversary20_world_bosses = {
   { world_bosses_originals = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 47254, info = "3w tokens", period = "weekly" } }) },
   { world_bosses_gatecrashers = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 60215, info = "3w tokens", period = "weekly" } }) },
}

local anniversary20_ordered2 = {
   { doomwalker = table_merge_shallow_left({ a_env.daily_boss_template, { quest_id = 60214, achievement_id = 40997, criteria_idx = 1 } }) },
   { sha_of_anger = table_merge_shallow_left({ a_env.daily_boss_template, { quest_id = 84282, achievement_id = 40997, criteria_idx = 2 } }) },
   { archavon = table_merge_shallow_left({ a_env.daily_boss_template, { quest_id = 84256, achievement_id = 40997, criteria_idx = 3 } }) },
   { kazzak = table_merge_shallow_left({ a_env.daily_boss_template, { quest_id = 47461, achievement_id = 40994, criteria_idx = 2 } }) },
   { azuregos = table_merge_shallow_left({ a_env.daily_boss_template, { quest_id = 47462, achievement_id = 40994, criteria_idx = 1 } }) },
   { ysondre = table_merge_shallow_left({ a_env.daily_boss_template, { quest_id = 43463, achievement_id = 40994, criteria_idx = 6 } }) },
   { lethon = table_merge_shallow_left({ a_env.daily_boss_template, { quest_id = 43464, achievement_id = 40994, criteria_idx = 3 } }) },
   { emeriss = table_merge_shallow_left({ a_env.daily_boss_template, { quest_id = 43465, achievement_id = 40994, criteria_idx = 4 } }) },
   { taerar = table_merge_shallow_left({ a_env.daily_boss_template, { quest_id = 43466, achievement_id = 40994, criteria_idx = 5 } }) },
}

function a_env.OutputTablesAnniversary20()
   local output_tables = {}
   local output_table

   output_tables[1] = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(anniversary20_ordered1))
   output_tables[1].header = anniversary20_header

   output_table = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(anniversary20_world_bosses))
   output_table.none_active = { name = "Anniversary World Bosses", info = output_table[1].info, state = output_table[1].state, period = output_table[1].period }
   a_env.OutputTableLeaveOnlyActiveQuest(output_table)
   output_tables[2] = output_table

   output_tables[3] = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(anniversary20_ordered2))

   return output_tables
end

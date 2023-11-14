local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local table_add_pairs = _G["SR13-Lib"].pair_utils.table_add_pairs
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals

local objectives_branch = a_env.objectives.reputation

local valdrakken_accord = {
   { valdrakken_noevent = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70750 } }) },
   { valdrakken_dragonbane = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 72374 } }) },
   { valdrakken_zskera = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 75259 } }) },
   { valdrakken_sniffenseeking = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 75859 } }) },
   { valdrakken_researchers = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 75860 } }) },
   { valdrakken_suffusion = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 75861 } }) },
   { valdrakken_time_rift = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 77254 } }) },
   { valdrakken_dreamsurge = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 77976 } }) },
}

table_add_pairs(objectives_branch, valdrakken_accord)

objectives_branch.loamm_niffen = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 75665, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } })
-- Complete 5 Heroic, Fighting is its own reward, TODO: LOAM NIFFEN AND AIDING THE ACCORD + rep buff MUST BE ACTIVE BEFORE TURNING IN!
a_env.objectives.valdrakken_heroic = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 76122, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } })

function a_env.OutputTableDragonflightReputation()
   local output_table = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(valdrakken_accord))
   output_table.all_completed = { name = output_table[1].name, state = output_table[1].state, period = output_table[1].period }
   output_table.none_active = { name = output_table[1].name, state = output_table[1].state, period = output_table[1].period }

   a_env.OutputTableLeaveOnlyActiveQuest(output_table)

   return output_table
end

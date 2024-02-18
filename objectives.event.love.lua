local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals

local love_header = { name = "Love is in the Air", header = true }
local love_ordered = {
   { one_time = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 78985, info = "One-time storyline, 100+ tokens", period = "event" } }) },
   { crown_chemical_co = a_env.objectives.event_love.crown_chemical_co },
}
local love_getaway = {
   { nagrand = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 78987, info = "Scenic Getaway" } }) },
   { feralas = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 78988, info = "Scenic Getaway" } }) },
}
local love_yourself = {
   { relief = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 78990, info = "Love Yourself" } }) },
   { relaxation = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 78991, info = "Love Yourself" } }) },
}

function a_env.OutputTablesLove()
   local output_tables = {}
   local output_table

   output_tables[1] = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(love_ordered))
   output_tables[1].header = love_header
   output_tables[1].header.info = ("tokens: %d"):format(GetItemCount(49927, true, true, true))

   output_table = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(love_getaway))
   output_table.none_active = { name = output_table[1].info, info = output_table[1].info, state = output_table[1].state, period = output_table[1].period }
   a_env.OutputTableLeaveOnlyActiveQuest(output_table)
   output_tables[2] = output_table

   output_table = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(love_yourself))
   output_table.none_active = { name = output_table[1].info, info = output_table[1].info, state = output_table[1].state, period = output_table[1].period }
   a_env.OutputTableLeaveOnlyActiveQuest(output_table)
   output_tables[3] = output_table

   return output_tables
end

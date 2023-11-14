local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals

a_env.objectives.event_hallowsend = a_env.objectives.event_hallowsend or {}

local hallowsend_header = { name = "Hallow's End", header = true }
local hallowsend_ordered = {
   { headless_horseman = a_env.objectives.event_hallowsend.dungeon_headless_horseman },
   { town_smash_pumpkin = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 12155, info = "Towns" } }) },
   { undercity_cleanup = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 29375, info = "Undercity", progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } }) },
   { undercity_buildup = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 29376, info = "Undercity" } }) },
   { valsharah_witch = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 43162 } }) },
   { shadowmoon_crew = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 39721, info = "Draenor, Shadowmoon" } }) },
   { shadowmoon_fertilizer = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 39720, info = "Draenor, Shadowmoon" } }) },
   {   shadowmoon_captain = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 39719, info = "Draenor, Shadowmoon" } }) },
   { shadowmoon_squashlings = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 39716, info = "Draenor, Shadowmoon" } }) },
}

function a_env.OutputTableHallowsEnd()
   do return {} end
   local output_table = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(hallowsend_ordered))
   output_table.header = hallowsend_header
   output_table.header.info = ("tokens: %d"):format(GetItemCount(33226, true, true, true))
   return output_table
end

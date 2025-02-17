local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local table_add_pairs = _G["SR13-Lib"].pair_utils.table_add_pairs
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals

local objectives_branch = a_env.objectives.reputation

local last_hurrah_progress = {
   [80385] = { -- Isles
      [1] = 'Feast',
      [2] = 'Hunt',
      [3] = 'Dragonbane',
   },
   [80386] = { -- Zaralek
      [1] = 'Research',
      [2] = 'Suffusion',
      [3] = 'TR',
   },
   [80388] = { -- Emerald Dream
      [1] = 'Surge',
      [2] = 'Superbloom',
      [3] = 'Superbloom',
      [4] = 'Seeds'
   },

}

local function GetObjectiveLastHurrahProgressString(objective)
   local sub_obj = {}
   for idx = 1, #last_hurrah_progress[objective.quest_id] do
      local val = last_hurrah_progress[objective.quest_id][idx]
      local _
      _, _, sub_obj_finished, fulfilled, required = GetQuestObjectiveInfo(objective.quest_id, idx, false)
      local color = sub_obj_finished and GREEN_FONT_COLOR or RED_FONT_COLOR
      if (not sub_obj_finished) and (objective.quest_id == 80388) and (idx ~= 3) then val = fulfilled .. '/' .. (required or '??') end
      sub_obj[idx] = color:WrapTextInColorCode(val)
   end

   -- Two sub-objectives are related to superbloom, custom-handling to pack them together
   if objective.quest_id == 80388 then
      local _, _, obj50_complete = GetQuestObjectiveInfo(objective.quest_id, 2, false)
      if not obj50_complete then
         table.remove(sub_obj, 3)
      else
         table.remove(sub_obj, 2)
      end
   end

   local progress = table.concat(sub_obj, ' ')
   return "ok", progress
end

local valdrakken_accord = {
   -- Can't be picked up, added only so group can assume this quest name
   { last_hurrah = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 80389 } }) },

   { valdrakken_noevent = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70750 } }) },
   { valdrakken_dragonbane = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 72374 } }) },
   { valdrakken_zskera = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 75259 } }) },
   { valdrakken_sniffenseeking = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 75859 } }) },
   { valdrakken_researchers = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 75860 } }) },
   { valdrakken_suffusion = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 75861 } }) },
   { valdrakken_time_rift = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 77254 } }) },
   { valdrakken_dreamsurge = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 77976 } }) },
   { valdrakken_superbloom = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 78446 } }) },
   { valdrakken_emerald_bounty = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 78447 } }) },

   -- Previous quests are unavailable to be picked any more, but they BLOCK this following new group until completed/dropped.
   -- This block can't be picked up either after DF is over, but can still be turned in.
   { last_hurrah_isles = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 80385, progress = GetObjectiveLastHurrahProgressString } }) },
   { last_hurrah_zaralek = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 80386, progress = GetObjectiveLastHurrahProgressString } }) },
   { last_hurrah_emerald_dream = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 80388, progress = GetObjectiveLastHurrahProgressString } }) },
}

table_add_pairs(objectives_branch, valdrakken_accord)

a_env.emerald_dream_base_reward = a_env.dfs4_adventurer

objectives_branch.loamm_niffen = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 75665, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } })
objectives_branch.dream_wardens = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 78444, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString, info = ("random %s"):format(a_env.emerald_dream_base_reward), } })

-- Complete 5 Heroic, Fighting is its own reward, TODO: LOAM NIFFEN AND AIDING THE ACCORD + rep buff MUST BE ACTIVE BEFORE TURNING IN!
a_env.objectives.valdrakken_heroic = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 76122, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } })
a_env.objectives.valdrakken_heroic.available = false -- Removed in 10.2. Permanently? Temporarily?

local do_not_show = {}
function a_env.OutputTableDragonflightReputations()
   local output_table = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(valdrakken_accord))
   output_table.all_completed = { name = output_table[1].name, state = output_table[1].state, period = output_table[1].period }
   output_table.none_active = do_not_show
   a_env.OutputTableLeaveOnlyActiveQuest(output_table)

   local output_tables = {
      a_env.CalculateObjectivesToOutputTable({
         objectives_branch.loamm_niffen,
         objectives_branch.dream_wardens,
      })
   }
   if output_table[1] ~= do_not_show then table.insert(output_tables, 1, output_table) end

   return output_tables
end

local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local table_add_pairs = _G["SR13-Lib"].pair_utils.table_add_pairs
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals

local function GetNameFromAchievementID(objective)
   if not objective.achievement_id then return "cache", "<.achievement_id not set>" end
   local id, name = GetAchievementInfo(objective.achievement_id)
   return "cachenonempty", name
end

local lfg_dailies = {
   { daily_scenario = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 80448 } }) },
   { daily_dungeon = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 80446 } }) },
   { daily_raid = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 80447 } }) },
}

local daily_boss_template = table_merge_shallow_left({ a_env.daily_quest_template, { name = GetNameFromAchievementID } })
local world_bosses = {
   { galleon = table_merge_shallow_left({ daily_boss_template, { quest_id = 32098, achievement_id = 20017 } }) },
   { sha = table_merge_shallow_left({ daily_boss_template, { quest_id = 32099, achievement_id = 20018 } }) },
   { nalak = table_merge_shallow_left({ daily_boss_template, { quest_id = 32518, achievement_id = 20019 } }) },
   { oondasta = table_merge_shallow_left({ daily_boss_template, { quest_id = 32519, achievement_id = 20020 } }) },
   { celestials = table_merge_shallow_left({ daily_boss_template, { quest_id = 33117, achievement_id = 8535 } }) },
   { ordos = table_merge_shallow_left({ daily_boss_template, { quest_id = 33118, achievement_id = 8533 } }) },
}

function a_env.OutputTablesWoWRemix()
   local output_tables = {}
   local output_table

   local idx = 1
   output_tables[idx] = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(lfg_dailies))
   output_tables[idx].header = { name = "LFG Daily Quests" }

   idx = idx + 1
   output_tables[idx] = a_env.CalculateObjectivesToOutputTable(GetIncompleteLFG())
   output_tables[idx].header = { name = "LFG Daily First Reward" }

   idx = idx + 1
   output_tables[idx] = a_env.CalculateObjectivesToOutputTable(pairs_get_vals(world_bosses))
   output_tables[idx].header = { name = "Daily World Bosses" }

   return output_tables
end

local dunegon_functions = {
   { GetNumRandomScenarios, GetRandomScenarioInfo },
   { GetNumRandomDungeons,  GetLFGRandomDungeonInfo },
   { GetNumRFDungeons,      GetRFDungeonInfo },
}

local function Lazy_MakeInvertedBool(orig_func)
   return function(self)
      local cache_mode, res = orig_func(self)
      return cache_mode, not res
   end
end

local FirstRewardNotCompleted = Lazy_MakeInvertedBool(a_env.GetObjectiveLFGRandomFirstRewardCompleted)

local event_dungeon_objective_remove_completed_template = table_merge_shallow_left({ a_env.event_dungeon_objective_template, {
   available = FirstRewardNotCompleted,
}})

function GetIncompleteLFG()
   local objectives = {}
   local objectives_idx = 0

   for _, get_funcs in ipairs(dunegon_functions) do
      local get_num, get_info = get_funcs[1], get_funcs[2]

      for idx = 1, get_num() do
         local dungeon_id, dungeon_name = get_info(idx)
         if IsLFGDungeonJoinable(dungeon_id) then
            objectives_idx = objectives_idx + 1
            objectives[objectives_idx] = table_merge_shallow_left({ event_dungeon_objective_remove_completed_template, { lfg_dungeon_id = dungeon_id } })
         end
      end
   end

   return objectives
end

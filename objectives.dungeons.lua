local a_name, a_env = ...

-- [AUTOLOCAL START]
local GetLFGDungeonInfo = GetLFGDungeonInfo
local GetLFGDungeonRewards = GetLFGDungeonRewards
local GetLFGMode = GetLFGMode
local IsLFGDungeonJoinable = IsLFGDungeonJoinable
local _G = _G
-- [AUTOLOCAL END]

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left

function a_env.GetObjectiveLFGRandomDungeonName(self)
   local name = GetLFGDungeonInfo(self.lfg_dungeon_id)
   return "cachenonempty", name
end

function a_env.GetObjectiveLFGRandomDungeonAvailable(self)
   local joinable = IsLFGDungeonJoinable(self.lfg_dungeon_id)
   if joinable then return "ok", "IsLFGDungeonJoinable" end
end

function a_env.GetObjectiveLFGRandomFirstRewardCompleted(self)
   local doneToday, moneyAmount, moneyVar, experienceGained, experienceVar, numRewards, spellID = GetLFGDungeonRewards(self.lfg_dungeon_id)
   if doneToday then return "ok", true end
end

local lfg_mode_any_queued = {
   queued    = true,
   rolecheck = true,
   proposal  = true,
   suspended = true,
   lfgparty  = true,
}
function a_env.GetObjectiveLFGRandomDungeonState(self)
   local default_state = a_env.GetLazy(self, a_env.GetObjectiveStateDefault)
   -- if it's anything but "available" - return as-is...
   if default_state ~= "available" then return "ok", default_state end
   -- ...otherwise continue and enrich with queue data

   local mode, sub_mode = GetLFGMode(LE_LFG_CATEGORY_RF, self.lfg_dungeon_id)
   if lfg_mode_any_queued[mode] then return "ok", "queued" end

   return "ok", default_state
end

local event_dungeon_objective_template = {
   name = a_env.GetObjectiveLFGRandomDungeonName,
   state = a_env.GetObjectiveLFGRandomDungeonState,
   available = a_env.GetObjectiveLFGRandomDungeonAvailable,
   completed = a_env.GetObjectiveLFGRandomFirstRewardCompleted,
   period = "daily dungeon",
}
a_env.event_dungeon_objective_template = event_dungeon_objective_template

a_env.objectives.event_brewfest = a_env.objectives.event_brewfest or {}
a_env.objectives.event_brewfest.dungeon_coren = table_merge_shallow_left({ event_dungeon_objective_template, { lfg_dungeon_id = 287 } })
a_env.objectives.event_hallowsend = a_env.objectives.event_hallowsend or {}
a_env.objectives.event_hallowsend.dungeon_headless_horseman = table_merge_shallow_left({ event_dungeon_objective_template, { lfg_dungeon_id = 285 } })

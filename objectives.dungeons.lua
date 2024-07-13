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

local event_dungeon_objective_template = {
   name = a_env.GetObjectiveLFGRandomDungeonName,
   state = a_env.GetObjectiveStateDefault,
   available = a_env.GetObjectiveLFGRandomDungeonAvailable,
   completed = a_env.GetObjectiveLFGRandomFirstRewardCompleted,
   period = "daily dungeon",
}

a_env.objectives.event_brewfest = a_env.objectives.event_brewfest or {}
a_env.objectives.event_brewfest.dungeon_coren = table_merge_shallow_left({ event_dungeon_objective_template, { lfg_dungeon_id = 287 } })
a_env.objectives.event_hallowsend = a_env.objectives.event_hallowsend or {}
a_env.objectives.event_hallowsend.dungeon_headless_horseman = table_merge_shallow_left({ event_dungeon_objective_template, { lfg_dungeon_id = 285 } })

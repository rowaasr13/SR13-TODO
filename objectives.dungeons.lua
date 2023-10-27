local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left

local function GetLFGRandomDungeonInfoByDungeonId(required_dungeon_id) -- only returns info for dungeons available to player
   for idx = 1, GetNumRandomDungeons() do
      local id, name = GetLFGRandomDungeonInfo(idx)
      if id == required_dungeon_id then
         return id, name, IsLFGDungeonJoinable(id)
      end
   end
end

function a_env.GetObjectiveLFGRandomDungeonName(self)
   local id, name, joinable = GetLFGRandomDungeonInfoByDungeonId(self.lfg_dungeon_id)
   return "ok", name
end

function a_env.GetObjectiveLFGRandomDungeonAvailable(self)
   local id, name, joinable = GetLFGRandomDungeonInfoByDungeonId(self.lfg_dungeon_id)
   if joinable then return "ok", "IsLFGDungeonJoinable" end
   -- if C_UnitAuras.GetPlayerAuraBySpellID(self.aura_spell_id) then return "ok", "GetPlayerAuraBySpellID" end
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

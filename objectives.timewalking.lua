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

local function GetObjectiveLFGRandomDungeonName(self)
   local id, name, joinable = GetLFGRandomDungeonInfoByDungeonId(self.lfg_dungeon_id)
   return name
end

local function GetObjectiveLFGRandomDungeonAvailable(self)
   local id, name, joinable = GetLFGRandomDungeonInfoByDungeonId(self.lfg_dungeon_id)
   if joinable then return "IsLFGDungeonJoinable" end
   if C_UnitAuras.GetPlayerAuraBySpellID(self.aura_spell_id) then return "ok", "GetPlayerAuraBySpellID" end
end

local function GetObjectiveQuestPickedup(self)
   if C_QuestLog.GetLogIndexForQuestID(self.quest_id) then return "ok", "GetLogIndexForQuestID" end
end

local function AddObjectiveTimewalking(data)
   local self = data

   -- Dungeon run quest
   local new_objective = {
      lfg_dungeon_id = data.lfg_dungeon_id,
      aura_spell_id = data.aura_spell_id,
      quest_id = data.quest_id,

      name = GetObjectiveLFGRandomDungeonName,
      available = GetObjectiveLFGRandomDungeonAvailable,
      pickedup = GetObjectiveQuestPickedup,
      completed = GetObjectiveQuestCompleted,

   }
   AddObjectiveTimeWalking(new_objective)

   -- First run item turn-in quest
   local new_objective = {
      item_turn_in_item_id = data.item_turn_in_item_id,
      item_turn_in_quest_id = data.item_turn_in_quest_id,
   }
   AddObjectiveTimeWalking(new_objective)
end

local timewalking_lichking = {
   lfg_dungeon_id = 995,
   aura_spell_id = 335149,
   quest_id = 72726,

   item_turn_in_item_id = 129928,
   item_turn_in_quest_id = 40173,
}

a_env.objectives.weekly_sign.timewalking_cataclysm = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 72810, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } })
a_env.objectives.weekly_sign.timewalking_cataclysm_token = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 40786 } }) -- add: item in inventory, item in inventory+no event - throw away
a_env.objectives.weekly_sign.timewalking_burning_crusade = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 72727, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } })
a_env.objectives.weekly_sign.timewalking_burning_crusade_token = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 40168 } }) -- add: item in inventory, item in inventory+no event - throw away

local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local table_add_pairs = _G["SR13-Lib"].pair_utils.table_add_pairs
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals

local header = { name = "Paragon Rewards", header = true }

local known_children = {}

local reward_quests = {}

local function BuildRewardQuestsList()
   wipe(reward_quests)

   local lastTopLevelHeader
   for index = 1, C_Reputation.GetNumFactions() do repeat
      local factionData = C_Reputation.GetFactionDataByIndex(index)
      if not factionData then break end
      local factionID = factionData.factionID

      local isTopLevelHeader = factionData.isHeader and not factionData.isChild
      if isTopLevelHeader then lastTopLevelHeader = factionID else known_children[factionID] = lastTopLevelHeader end

      if not C_Reputation.IsFactionParagon(factionID) then break end

      local currentValue, threshold, rewardQuestID, hasRewardPending, tooLowLevelForParagon = C_Reputation.GetFactionParagonInfo(factionID)
      if hasRewardPending then
         local parentName
         local parentID = known_children[factionID]
         if parentID then
            local parentData = C_Reputation.GetFactionDataByID(parentID)
            parentName = parentData and parentData.name
         end
         local name = factionData.name
         if (parentName) then name = parentName .. " > " .. name end
         reward_quests[#reward_quests + 1] = table_merge_shallow_left({ a_env.quest_template, { quest_id = rewardQuestID, info = name } })
         -- print(name)
         -- print("===") DevTools_Dump(factionData)
      end
   until true end
end


function a_env.OutputTableParagonRewards()
   BuildRewardQuestsList()
   if #reward_quests == 0 then return a_env.empty_table end

   local output_table = a_env.CalculateObjectivesToOutputTable(reward_quests)
   if #output_table > 0 then
      output_table.header = header
   end

   return output_table
end

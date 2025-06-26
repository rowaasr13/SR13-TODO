local a_name, a_env = ...

SV_SR13TODO = SV_SR13TODO or {}

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local array_of_pairs_iter = _G["SR13-Lib"].pair_utils.array_of_pairs_iter

function a_env.GetObjectiveStateDefault(objective)
   local available = a_env.GetLazy(objective, 'available')
   if not available then return "ok", "not available" end

   local completed = a_env.GetLazy(objective, 'completed')
   if completed then return "ok", "completed" end

   local turnin = (objective.turnin ~= nil) and a_env.GetLazy(objective, 'turnin')
   if turnin then return "ok", "turnin" end

   if objective.pickedup == nil then
      return "ok", "available"
   else
      local pickedup = a_env.GetLazy(objective, 'pickedup')
      if pickedup then
         return "ok", "pickedup"
       else
         return "ok", "notpickedup"
      end
   end
end

function a_env.CalculateObjectivesToOutputTable(objectives, mode)
   assert(objectives, "objectives is nil")
   local output = {}

   local iter_func, iter_state, iter_var
   if mode == "array_of_pairs" then
      iter_func, iter_state, iter_var = array_of_pairs_iter(objectives)
   else
      iter_func, iter_state, iter_var = ipairs(objectives)
   end

   local output_idx = 1
   for idx, v1, v2 in iter_func, iter_state, iter_var do repeat
      local objective
      if mode == "array_of_pairs" then objective = v2 else objective = v1 end

      local available = a_env.GetLazy(objective, "available")
      if not available then break end -- we don't display non-available at all, no reason to calculate rest of data
      local state = a_env.GetLazy(objective, "state")
      local state_color = a_env.state_colors[state]
      local name = a_env.GetLazy(objective, "name")
      local info = objective.info and a_env.GetLazy(objective, "info")
      local period = objective.period and a_env.GetLazy(objective, "period")
      local progress = (state == "pickedup") and (objective.progress ~= nil) and a_env.GetLazy(objective, "progress")

      local output_line = {
         available = available,
         state = state,
         state_color = state_color,
         progress = progress,
         name = name,
         info = info,
         period = period,
      }
      output[output_idx] = output_line
      output_idx = output_idx + 1
   until true end

   return output
end

-- Works with preprocessed output tables.
-- If one quest is active (pickedup/turnin/completed) then entire table is replaced with only this quest.
-- If all quest are completed, then entire table is replaced with special output from .all_completed.
-- If none of quest are completed or active, then entire table is replaced with special output from .none_active.
function a_env.OutputTableLeaveOnlyActiveQuest(output_table)
   if #output_table == 0 then return end

   local completed_count = 0
   -- (bool) all quests in group are completed (often used with random dailies/weeklies when you get one random quest from group)
   local active_objective

   for idx = 1, #output_table do
      local objective = output_table[idx]
      if objective.state == "pickedup" or objective.state == "turnin" or objective.state == "completed" then
         active_objective = objective
         if objective.state == "completed" then
            completed_count = completed_count + 1
         end
      end
   end

   if (not active_objective) and output_table.none_active then
      if output_table.debug == true then print(output_table, "none_active") end
      local objective = output_table.none_active
      wipe(output_table)
      output_table[1] = objective
      return output_table
   end

   if (completed_count == #output_table) and output_table.all_completed then
      if output_table.debug == true then print(output_table, "all_completed") end
      local objective = output_table.all_completed
      wipe(output_table)
      output_table[1] = objective
      return output_table
   end

   if (completed_count >= 1) and output_table.any_completed then
      if output_table.debug == true then print(output_table, "any_completed") end
      local objective = output_table.any_completed
      wipe(output_table)
      output_table[1] = objective
      return output_table
   end

   if active_objective then
      if output_table.debug == true then print(output_table, "active_objective") end
      wipe(output_table)
      output_table[1] = active_objective
   end

   return output_table
end

function a_env.GetObjectiveItemName(objective)
   local name = GetItemInfo(objective.item_id)
   return "cachenonempty", name
end

a_env.state_colors = {
   ["completed"] = GREEN_FONT_COLOR,
   ["pickedup"] = YELLOW_FONT_COLOR,
   ["turnin"] = YELLOW_FONT_COLOR,
   ["inbags"] = YELLOW_FONT_COLOR,
   ["queued"] = YELLOW_FONT_COLOR,
   ["itemmissing"] = RED_FONT_COLOR,
}

a_env.state_display_text = {
   ["pickedup"] = "picked up",
   ["turnin"] = "turn-in",
   ["notpickedup"] = "not picked up",
   ["inbags"] = "still in bags",
   ["itemmissing"] = "missing!",
}

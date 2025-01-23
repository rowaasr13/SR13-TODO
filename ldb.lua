local a_name, a_env = ...

local broker = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(a_name, {type = "data source", label = a_name, text = a_name})
local qtip = LibStub("LibQTip-1.0")

local tooltip

local function AddSingleObjectiveLine(tooltip, objective)
   assert(tooltip, ("tooltip is %q"):format(tostring(tooltip)))
   assert(objective, ("objective is %q"):format(tostring(objective)))
   local state = a_env.GetLazy(objective, "state")
   if state == "not available" then return end
   local state_color = a_env.state_colors[state]
   local state_text
   local name = a_env.GetLazy(objective, "name")
   local info = objective.info and a_env.GetLazy(objective, "info")
   local period = objective.period and a_env.GetLazy(objective, "period")
   local progress = (state == "pickedup") and (objective.progress ~= nil) and a_env.GetLazy(objective, 'progress')
   local uncolored_state_text = progress or a_env.state_display_text[state] or state
   if state_color then state_text = state_color:WrapTextInColorCode(uncolored_state_text) else state_text = uncolored_state_text end
   tooltip:AddLine(name, state_text, info, period)
end
a_env.AddSingleObjectiveLine = AddSingleObjectiveLine -- TODO: TEMPORARY

-- Only adds processed lines, no lazy values.
local function AddSingleLineFromOutputTable(tooltip, line)
   if line.separator then
      return tooltip:AddSeparator()
   end

   if line.empty then
      return tooltip:AddLine()
   end

   local name = line.name
   local state = line.state
   if state == "not available" then return end
   local state_color = line.state_color or a_env.state_colors[state]
   local state_text
   local info = line.info
   local period = line.period
   local progress = (state == "pickedup") and line.progress
   local uncolored_state_text = progress or a_env.state_display_text[state] or state
   if state_color then state_text = state_color:WrapTextInColorCode(uncolored_state_text) else state_text = uncolored_state_text end
   local method = line.header and "AddHeader" or "AddLine"
   tooltip[method](tooltip, name, state_text, info, period)
end

local function AddOutputTable(tooltip, output_table)
   assert(tooltip, ("tooltip is %q"):format(tostring(tooltip)))
   assert(output_table, ("output_table is %q"):format(tostring(output_table)))

   local line = output_table.header
   if line then
      tooltip:AddSeparator()
      AddSingleLineFromOutputTable(tooltip, line)
   end

   for idx = 1, #output_table do
      local line = output_table[idx]
      AddSingleLineFromOutputTable(tooltip, line)
   end
end

local function AddOutputTables(tooltip, output_tables)
   for idx = 1, #output_tables do
      AddOutputTable(tooltip, output_tables[idx])
   end
end

local function DoNothing() end

local function broker_OnLeave(self)
   tooltip:SetScale(1)
   qtip:Release(tooltip)
   tooltip = nil
end
broker.OnLeave = broker_OnLeave

local function tooltip_RescaleToScreen(tooltip, args)
   -- TODO: incorrect, must calculate only size occupied from smart anchor
   local tooltip_height = tooltip:GetHeight() * tooltip:GetEffectiveScale()
   local uiparent_height = UIParent:GetHeight() * UIParent:GetEffectiveScale()
   tooltip_height = tooltip_height + 15
   if (tooltip_height > uiparent_height) then
      if not (args and args.recursion and args.recursion > 5) then
         local scale = (uiparent_height / tooltip_height) * ((args and args.rescale) or 1)
         local new_args = {
            rescale = scale,
            recursion = ((args and args.recursion) or 0) + 1
         }
         return new_args
      else
         assert(true, "Deep recursion protection - should not happen?")
      end
   end
end

local function broker_OnEnter(self, args)
   local AddSingleObjectiveLine = AddSingleObjectiveLine
   local AddOutputTable = AddOutputTable
   local AddOutputTables = AddOutputTables

   if args and args.show == false then
      AddSingleObjectiveLine = DoNothing
      AddOutputTable = DoNothing
      AddOutputTables = DoNothing
   else
      tooltip = qtip:Acquire(a_name, 4, "LEFT", "CENTER", "LEFT", "CENTER")
      tooltip:AddHeader("Objective", "State", "Info", "Period")
      tooltip:AddSeparator()
   end

   AddSingleObjectiveLine(tooltip, a_env.objectives.valdrakken_heroic)
   AddOutputTable(tooltip, a_env.OutputTableWeeklySign())
   AddOutputTable(tooltip, a_env.OutputTableTimewalking())
   AddSingleObjectiveLine(tooltip, a_env.objectives.darkmoon_faire.ears)

   AddOutputTables(tooltip, a_env.OutputTableDragonflightReputations())
   AddOutputTables(tooltip, a_env.OutputTableDragonflightWorldBosses())
   AddOutputTables(tooltip, a_env.OutputTableDragonflightEvents())

   AddOutputTables(tooltip, a_env.OutputTablesProfessions())
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession.valdrakken_mettle)

   AddOutputTable(tooltip, a_env.OutputTableHallowsEnd())
   AddOutputTable(tooltip, a_env.OutputTableWinterVeil())
   AddOutputTables(tooltip, a_env.OutputTablesLove())

   if args and args.show == false then
      -- do nothing
   else
      tooltip:SmartAnchorTo(self)

      local new_args = tooltip_RescaleToScreen(tooltip, args)
      if new_args then
         broker_OnLeave(self)
         return broker_OnEnter(self, new_args)
      end

      tooltip:Show()
   end
end
broker.OnEnter = broker_OnEnter

local function AllOutputTables()
   broker:OnEnter({ show = false })
end
for _, timer in ipairs({ 1, 2, 5, 10, 30 }) do
   C_Timer.After(timer, AllOutputTables) -- Trigger to pre-load data
end

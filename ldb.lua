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
   tooltip:AddLine(name, state_text, info, period)
end

local function AddOutputTable(tooltip, output_table)
   assert(tooltip, ("tooltip is %q"):format(tostring(tooltip)))
   assert(output_table, ("output_table is %q"):format(tostring(output_table)))

   for idx = 1, #output_table do
      local objective = output_table[idx]
      AddSingleLineFromOutputTable(tooltip, objective)
   end
end

function broker:OnEnter()
   tooltip = qtip:Acquire(a_name, 4, "LEFT", "CENTER", "LEFT", "CENTER")
   tooltip:AddHeader("Objective", "State", "Info", "Period")
   tooltip:AddSeparator()

   AddSingleObjectiveLine(tooltip, a_env.objectives.valdrakken_heroic)
   -- AddSingleObjectiveLine(tooltip, a_env.objectives.weekly_sign.world_quests)
   AddOutputTable(tooltip, a_env.OutputTableTimewalking())
   -- AddSingleObjectiveLine(tooltip, a_env.objectives.darkmoon_faire.ears)

   AddOutputTable(tooltip, a_env.OutputTableDragonflightReputation())
   AddSingleObjectiveLine(tooltip, a_env.objectives.reputation.loamm_niffen)
   AddSingleObjectiveLine(tooltip, a_env.objectives.worldboss.zaqali_elders)
   AddSingleObjectiveLine(tooltip, a_env.objectives.dreamsurge.investigation)
   AddSingleObjectiveLine(tooltip, a_env.objectives.dreamsurge.shaping)

   tooltip:AddSeparator()
   tooltip:AddHeader("Professions")
   for _, output_table  in ipairs(a_env.OutputTablesProfessions()) do
      AddOutputTable(tooltip, output_table)
   end
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession_enchanting.valdrakken_bracer_leech)
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession_enchanting.loamm_relic)
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession_blacksmithing.valdrakken_explorer_boots)
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession_blacksmithing.loamm_plate)
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession_blacksmithing.orders)
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession_jewelcrafting.loamm_whelkshell)
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession_inscription.loamm_proclamation)
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession.valdrakken_mettle)

   tooltip:SmartAnchorTo(self)
   tooltip:Show()
end

function broker:OnLeave()
   qtip:Release(tooltip)
   tooltip = nil
end


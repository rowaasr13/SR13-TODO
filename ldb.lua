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
   if state_color then state_text = state_color:WrapTextInColorCode(state) else state_text = state end
   tooltip:AddLine(name, state_text, info, period)
end

function broker:OnEnter()
   tooltip = qtip:Acquire(a_name, 4, "LEFT", "CENTER", "LEFT", "CENTER")
   tooltip:AddHeader("Objective", "State", "Info", "Period")
   tooltip:AddSeparator()

   AddSingleObjectiveLine(tooltip, a_env.objectives.valdrakken_heroic)
   AddSingleObjectiveLine(tooltip, a_env.objectives.weekly_sign.world_quests)
   AddSingleObjectiveLine(tooltip, a_env.objectives.weekly_sign.timewalking_cataclysm)
   AddSingleObjectiveLine(tooltip, a_env.objectives.reputation.valdrakken_noevent)
   AddSingleObjectiveLine(tooltip, a_env.objectives.reputation.valdrakken_dragonbane)
   AddSingleObjectiveLine(tooltip, a_env.objectives.reputation.valdrakken_dreamsurge)
   AddSingleObjectiveLine(tooltip, a_env.objectives.reputation.loamm_niffen)
   AddSingleObjectiveLine(tooltip, a_env.objectives.worldboss.zaqali_elders)
   AddSingleObjectiveLine(tooltip, a_env.objectives.dreamsurge.investigation)
   AddSingleObjectiveLine(tooltip, a_env.objectives.dreamsurge.shaping)

   tooltip:AddSeparator()
   tooltip:AddHeader("Brewfest", nil, ("tokens: %d"):format(GetItemCount(37829, true, true, true)))
   AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.valdrakken_barrels)
   AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.valdrakken_bubbles)
   AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.orgrimmar_bark_tchali)
   AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.orgrimmar_bark_drohn)
   AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.orgrimmar_invasion_direbrew)
   AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.orgrimmar_invasion_hozen)
   AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.orgrimmar_racing)
   AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.dungeon_coren)

   tooltip:AddSeparator()
   tooltip:AddHeader("Professions")
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession_mining.valdrakken_serevite)
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession_herbalism.valdrakken_saxifrage)
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession_herbalism.valdrakken_bracer_leech)
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession_tailoring.valdrakken_surveyor_robe)
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession_blacksmithing.valdrakken_explorer_boots)
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession_tailoring.valdrakken_simple_reagent_bag)
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession_alchemy.valdrakken_reclaim)
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession_alchemy.valdrakken_healing_potion)
   AddSingleObjectiveLine(tooltip, a_env.objectives.profession.valdrakken_mettle)

   tooltip:SmartAnchorTo(self)
   tooltip:Show()
end

function broker:OnLeave()
   qtip:Release(tooltip)
   tooltip = nil
end


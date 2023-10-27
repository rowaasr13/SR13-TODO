local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left

a_env.objectives.event_brewfest = a_env.objectives.event_brewfest or {}
a_env.objectives.event_brewfest.valdrakken_barrels = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 77208, info = "Valdrakken" } })
a_env.objectives.event_brewfest.valdrakken_bubbles = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 76591, info = "Valdrakken" } })

a_env.objectives.event_brewfest.orgrimmar_bark_drohn = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 11407, info = 'Orgrimmar Bark' } })
a_env.objectives.event_brewfest.orgrimmar_bark_tchali = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 11408, info = 'Orgrimmar Bark' } })

a_env.objectives.event_brewfest.orgrimmar_invasion_hozen = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 56715, info = 'Orgrimmar Invasion' } })
a_env.objectives.event_brewfest.orgrimmar_invasion_direbrew = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 56716, info = 'Orgrimmar Invasion' } })

a_env.objectives.event_brewfest.orgrimmar_racing = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 29393 } })

   -- tooltip:AddSeparator()
   -- tooltip:AddHeader("Brewfest", nil, ("tokens: %d"):format(GetItemCount(37829, true, true, true)))
   -- AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.valdrakken_barrels)
   -- AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.valdrakken_bubbles)
   -- AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.orgrimmar_bark_tchali)
   -- AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.orgrimmar_bark_drohn)
   -- AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.orgrimmar_invasion_direbrew)
   -- AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.orgrimmar_invasion_hozen)
   -- AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.orgrimmar_racing)
   -- AddSingleObjectiveLine(tooltip, a_env.objectives.event_brewfest.dungeon_coren)

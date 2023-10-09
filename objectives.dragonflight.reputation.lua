local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left

local objectives_branch = a_env.objectives.reputation

objectives_branch.valdrakken_noevent = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 70750 } })
objectives_branch.valdrakken_dragonbane = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 72374 } })
objectives_branch.valdrakken_zskera = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 75259 } })
objectives_branch.valdrakken_dreamsurge = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 77976 } })
a_env.objectives.valdrakken_heroic = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 76122, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } }) -- Complete 5 Heroic, Fighting is its own reward
objectives_branch.loamm_niffen = table_merge_shallow_left({ a_env.weekly_quest_template, { quest_id = 75665, progress = a_env.GetObjectiveQuestSingleObjectiveProgressString } })

function a_env.OutputTableDragonflightReputation()
   local output_table = a_env.CalculateObjectivesToOutputTable({
      objectives_branch.valdrakken_noevent,
      objectives_branch.valdrakken_dragonbane,
      objectives_branch.valdrakken_zskera,
      objectives_branch.valdrakken_dreamsurge,
   })

   a_env.OutputTableLeaveOnlyActiveQuest(output_table)

   return output_table
end

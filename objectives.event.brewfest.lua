local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left

a_env.objectives.event_brewfest = {}
a_env.objectives.event_brewfest.valdrakken_barrels = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 77208, info = "Valdrakken" } })
a_env.objectives.event_brewfest.valdrakken_bubbles = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 76591, info = "Valdrakken" } })

a_env.objectives.event_brewfest.orgrimmar_bark_drohn = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 11407, info = 'Orgrimmar Bark' } })
a_env.objectives.event_brewfest.orgrimmar_bark_tchali = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 11408, info = 'Orgrimmar Bark' } })

a_env.objectives.event_brewfest.orgrimmar_invasion_hozen = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 56715, info = 'Orgrimmar Invasion' } })
a_env.objectives.event_brewfest.orgrimmar_invasion_direbrew = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 56716, info = 'Orgrimmar Invasion' } })

a_env.objectives.event_brewfest.orgrimmar_racing = table_merge_shallow_left({ a_env.daily_quest_template, { quest_id = 29393 } })

a_env.objectives.event_brewfest.dungeon_coren = {
   lfg_dungeon_id = 287,

   name = a_env.GetObjectiveLFGRandomDungeonName,
   state = a_env.GetObjectiveStateDefault,
   available = a_env.GetObjectiveLFGRandomDungeonAvailable,
   completed = a_env.GetObjectiveLFGRandomFirstRewardCompleted,
   period = "daily dungeon",
}

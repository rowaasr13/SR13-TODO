local a_name, a_env = ...

local objective_example = {
   name = function() end,      -- function that return human-readable objective name,
   available = function() end, -- function that returns true if objective is available and should be tracked,
   pickedup = function() end,  -- (optional) function that returns true if objective is picked up, not required as it is only available for traditional quests or inventory items
   turnin = function() end,    -- (optional) function that returns true if objective is ready to turn in (after picked up), not required as it is only available for traditional quests or inventory items
   completed = function() end, -- function that returns true if objective is completed,
}

a_env.objectives = {
   worldboss = {},
   reputation = {},
   profession = {},
   weekly_sign = {},
}

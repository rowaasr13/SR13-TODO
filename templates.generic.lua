local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local table_add_pairs = _G["SR13-Lib"].pair_utils.table_add_pairs
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals

function a_env.LGO_State_MustBeCompleted(objective)
   local completed = a_env.GetLazy(objective, "completed")
   return "ok", completed and "completed" or "mustbecompleted"
end

function a_env.LGO_State_MustBeCompletedOnce(objective)
   local completed = a_env.GetLazy(objective, "completed")
   if completed then return "cachenonnil", "completed" end
   return "ok", "mustbecompleted"
end

function a_env.LGO_Available_MustBeCompletedOnce(objective)
   local completed = a_env.GetLazy(objective, "completed")
   if completed then return "cachefalsy", false end
   return "ok", "mustbecompleted"
end

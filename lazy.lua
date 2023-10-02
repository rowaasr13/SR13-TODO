local a_name, a_env = ...

function a_env.GetLazy(tbl, key)
   local res
   local val = tbl[key]
   assert(val ~= nil, ("value for key %q is nil"):format(key))
   if type(val) == "function" then res, val = val(tbl) end

   return val
end

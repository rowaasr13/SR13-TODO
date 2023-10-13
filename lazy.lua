local a_name, a_env = ...

function a_env.GetLazy(tbl, key)
   local res
   local val = tbl[key]
   local val_fixed = val
   assert(val ~= nil, ("value for key %q is nil"):format(key))
   if type(val) == "function" then res, val = val(tbl) end

   if type(tbl.debug) == 'table' then
      print(tbl, key, val_fixed, val)
   end

   return val
end

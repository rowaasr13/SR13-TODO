local a_name, a_env = ...

local type = type

-- Lazily "gets" value from table
-- In simplest case returns value residing in tbl at key.
-- If that value is a function, tries to run that function to get actual value with table as argument.
-- If key is a function (and there previously was no fixed/cached value returned), tries to run this function to get actual value with table as argument.
-- 1st return signifies caching mode, 2nd - actual value, result is cached as fixed (non-function) value in table with at slot key if it fits caching mode.
-- Returns actual value
function a_env.GetLazy(tbl, key)
   local val = tbl[key]
   local val_fixed = val

   local key_is_func
   if val == nil then
      if type(key) == "function" then key_is_func = true else
         local debug_id_msg = tbl.debug_id and (" (debug_id: %s)"):format(tbl.debug_id) or ''
         DevTools_Dump(tbl)
         assert(false, ("value for key %q is nil%s"):format(key, debug_id_msg))
      end
   end

   local res

   if type(val) == "function" then
      res, val = val(tbl)
   elseif key_is_func then
      res, val = key(tbl)
   end

   if res == "cachenonnil" and val ~= nil then
      tbl[key] = val
   end

   if type(tbl.debug) == 'table' then
      print(tbl, key, val_fixed, val)
   end

   return val
end

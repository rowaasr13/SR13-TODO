local a_name, a_env = ...

local table_merge_shallow_left = _G["SR13-Lib"].table_utils.table_merge_shallow_left
local pair_get = _G["SR13-Lib"].pair_utils.pair_get
local pairs_get_vals = _G["SR13-Lib"].pair_utils.pairs_get_vals
local array_of_pairs_build_map = _G["SR13-Lib"].pair_utils.array_of_pairs_build_map

local dmf_header = { name = "Darkmoon Faire", header = true }
local dmf_ordered = {
   { ears = a_env.objectives.darkmoon_faire.ears },
}

local orderer_profession_enums = table_merge_shallow_left({ a_env.objectives.profession.orderer_profession_enums })
table.insert(orderer_profession_enums, Enum.Profession.Cooking)
table.insert(orderer_profession_enums, Enum.Profession.Fishing)

local source_data = a_env.objectives.profession.source_data

function a_env.OutputTablesDarkmoonFaire()
   -- local available = a_env.GetLazy(dmf_ordered.crown_chemical_co, 'available')
   -- if not available then return {} end

   local output_tables = {}
   local output_table

   output_tables[1] = a_env.CalculateObjectivesToOutputTable(dmf_ordered, "array_of_pairs")
   output_tables[1].header = dmf_header
   -- output_tables[1].header.info = ("tokens: %d"):format(GetItemCount(49927, true, true, true))

   for _, profession_enum in ipairs(orderer_profession_enums) do
      local profession_data = source_data[profession_enum] or {}

      local template_key = "darkmoon_faire"

      if profession_data[template_key] then
         local ok, profession_name = a_env.GetProfessionName({ profession = profession_enum })
         if not profession_name then profession_name = "profession_enum:" .. profession_enum end

         local output_table = a_env.CalculateObjectivesToOutputTable(profession_data[template_key], "array_of_pairs")
         output_table.profession_name = profession_name
         a_env.objectives.profession.output_table_postprocess[template_key](output_table)
         output_tables[#output_tables + 1] = output_table
      end
   end

   return output_tables
end

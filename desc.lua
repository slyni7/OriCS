data_desc={}
function data_manager_desc(desc,chk)
   if data_desc[desc] then
      return data_desc[desc]
   end
   return false
end

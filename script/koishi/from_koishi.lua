if not YGOPRO_VERSION or YGOPRO_VERSION=="Koishi" then return end

local core_aux = Auxiliary
if not Koishi then Koishi = {} end
Auxiliary = Koishi
Duel.LoadScript("koishi_proc_fusion.lua")
Duel.LoadScript("koishi_proc_synchro.lua")
Duel.LoadScript("koishi_proc_xyz.lua")
Auxiliary = core_aux

Debug.Message("Koishi Scripts succesfully loaded!")
Debug.Message("Use Koishi.function() instead of aux.function()!")
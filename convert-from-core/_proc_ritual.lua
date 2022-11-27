function Auxiliary.AddRitualProcUltimate(c,filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter)
	summon_location=summon_location or LOCATION_HAND
	local lvtype=0
	if greater_or_equal=="Greater" then
		lvtype=RITPROC_GREATER
	else
		lvtype=RITPROC_EQUAL
	end
	local extrafil=nil
	if grave_filter then
		extrafil=function(e,tp,eg,ep,ev,re,r,rp)
			return Duel.GetMatchingGroup(Auxiliary.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,grave_filter)
		end
	end
	Ritual.AddProc(c,lvtype,filter,level_function,nil,extrafil,nil,mat_filter,nil,summon_location)
end
function Auxiliary.RitualExtraFilter(c,f)
	return c:GetLevel()>0 and f(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
--Ritual Summon, geq fixed lv
function Auxiliary.AddRitualProcGreater(c,filter,summon_location,grave_filter,mat_filter)
	return Auxiliary.AddRitualProcUltimate(c,filter,Card.GetOriginalLevel,"Greater",summon_location,grave_filter,mat_filter)
end
function Auxiliary.AddRitualProcGreaterCode(c,code1,summon_location,grave_filter,mat_filter)
	Auxiliary.AddCodeList(c,code1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local mt=c:GetMetatable()
		mt.fit_monster={code1}
	end
	return Auxiliary.AddRitualProcGreater(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter)
end
--Ritual Summon, equal to fixed lv
function Auxiliary.AddRitualProcEqual(c,filter,summon_location,grave_filter,mat_filter)
	return Auxiliary.AddRitualProcUltimate(c,filter,Card.GetOriginalLevel,"Equal",summon_location,grave_filter,mat_filter)
end
function Auxiliary.AddRitualProcEqualCode(c,code1,summon_location,grave_filter,mat_filter)
	Auxiliary.AddCodeList(c,code1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local mt=c:GetMetatable()
		mt.fit_monster={code1}
	end
	return Auxiliary.AddRitualProcEqual(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter)
end
--Ritual Summon, equal to monster lv
function Auxiliary.AddRitualProcEqual2(c,filter,summon_location,grave_filter,mat_filter)
	return Auxiliary.AddRitualProcUltimate(c,filter,Card.GetLevel,"Equal",summon_location,grave_filter,mat_filter)
end
function Auxiliary.AddRitualProcEqual2Code(c,code1,summon_location,grave_filter,mat_filter)
	Auxiliary.AddCodeList(c,code1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local mt=c:GetMetatable()
		mt.fit_monster={code1}
	end
	return Auxiliary.AddRitualProcEqual2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter)
end
function Auxiliary.AddRitualProcEqual2Code2(c,code1,code2,summon_location,grave_filter,mat_filter)
	Auxiliary.AddCodeList(c,code1,code2)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local mt=c:GetMetatable()
		mt.fit_monster={code1,code2}
	end
	return Auxiliary.AddRitualProcEqual2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1,code2),summon_location,grave_filter,mat_filter)
end
--Ritual Summon, geq monster lv
function Auxiliary.AddRitualProcGreater2(c,filter,summon_location,grave_filter,mat_filter)
	return Auxiliary.AddRitualProcUltimate(c,filter,Card.GetLevel,"Greater",summon_location,grave_filter,mat_filter)
end
function Auxiliary.AddRitualProcGreater2Code(c,code1,summon_location,grave_filter,mat_filter)
	Auxiliary.AddCodeList(c,code1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local mt=c:GetMetatable()
		mt.fit_monster={code1}
	end
	return Auxiliary.AddRitualProcGreater2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter)
end
function Auxiliary.AddRitualProcGreater2Code2(c,code1,code2,summon_location,grave_filter,mat_filter)
	Auxiliary.AddCodeList(c,code1,code2)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local mt=c:GetMetatable()
		mt.fit_monster={code1,code2}
	end
	return Auxiliary.AddRitualProcGreater2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1,code2),summon_location,grave_filter,mat_filter)
end
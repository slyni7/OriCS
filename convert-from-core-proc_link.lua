function Auxiliary.AddLinkProcedure(c,f,min,max,gf)
	Link.AddProcedure(c,f,min,max,gf)
end
EFFECT_EXTRA_LINK_MATERIAL=358
function Auxiliary.LConditionFilter(c,f,lc)
	return (c:IsFaceup() or not c:IsOnField()) and c:IsCanBeLinkMaterial(lc) and (not f or f(c))
end
function Auxiliary.LExtraFilter(c,f,lc,tp)
	if c:IsLocation(LOCATION_ONFIELD) and not c:IsFaceup() then return false end
	if not c:IsCanBeLinkMaterial(lc) or f and not f(c) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do
		local tf=te:GetValue()
		local related,valid=tf(te,lc,nil,c,tp)
		if related then return true end
	end
	return false
end
function Auxiliary.GetLinkCount(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
function Auxiliary.GetLinkMaterials(tp,f,lc)
	local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function Auxiliary.LCheckOtherMaterial(c,mg,lc,tp)
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	local res1=false
	local res2=true
	for _,te in pairs(le) do
		local f=te:GetValue()
		local related,valid=f(te,lc,mg,c,tp)
		if related then res2=false end
		if related and valid then res1=true end
	end
	return res1 or res2
end
function Auxiliary.LUncompatibilityFilter(c,sg,lc,tp)
	local mg=sg:Filter(aux.TRUE,c)
	return not Auxiliary.LCheckOtherMaterial(c,mg,lc,tp)
end
function Auxiliary.LCheckGoal(sg,tp,lc,gf,lmat)
	return sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
		and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end

Duel.GetLinkedZone=aux.GetMMZonesPointedTo
Card.IsLinkState=Card.IsLinked
local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	if c:IsStatus(STATUS_INITIALIZING) and (e:IsHasCategory(CATEGORY_DRAW) or e:IsHasCategory(CATEGORY_SEARCH)) then
		mt.akashic_exile_filter=true
	end
	cregeff(c,e,forced,...)
end
function Duel.GetDeckbottomGroup(tp,ct)
	local dc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK,0,nil)
	local sg=Duel.GetDecktopGroup(tp,dc-ct)
	g:Sub(sg)
	return g
end
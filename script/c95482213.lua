--아스트레이 드바라팔라
function c95482213.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcGreater2(c,c95482213.fil11,LOCATION_HAND+LOCATION_DECK,nil,c95482213.fil12)
end
function c95482213.fil11(c)
	return c:IsSetCard(0xd53)
end
function c95482213.fil12(c)
	return c:IsSetCard(0xd53) and not c:IsLocation(LOCATION_HAND)
end
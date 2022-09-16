--카노화!
function c84320047.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,84320047)
	e1:SetCost(c84320047.cost)
	e1:SetTarget(c84320047.target)
	e1:SetOperation(c84320047.drop)
	c:RegisterEffect(e1)
	--act qp in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_HAND)
	c:RegisterEffect(e2)
end
function c84320047.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,1600)
	end
	Duel.PayLPCost(tp,1600)
end
function c84320047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if chk==0 then
		return #g>0
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c84320047.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if #g>0 then
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,84320042) then
			Duel.BreakEffect()
			Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)+1000000))
		end
	end
end	
	
	
	
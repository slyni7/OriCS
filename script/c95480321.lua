--천명으로 비추는 빛
function c95480321.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43202238,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480321+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95480321.destg)
	e1:SetOperation(c95480321.desop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5795980,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c95480321.atcon)
	e2:SetOperation(c95480321.atop)
	c:RegisterEffect(e2)
end
function c95480321.desfilter(c)
	return c:IsSetCard(0xd41) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c95480321.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480321.desfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c95480321.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c95480321.desfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		if tc:GetType()==TYPE_TRAP+TYPE_CONTINUOUS then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function c95480321.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c95480321.atop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetOperation(c95480321.chainop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95480321.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsType(TYPE_TRAP) then
		Duel.SetChainLimit(c95480321.chainlm)
	end
end
function c95480321.chainlm(e,rp,tp)
	return tp==rp
end
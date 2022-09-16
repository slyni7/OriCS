--유키-상승하는 기류
function c84320002.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84320002,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(c84320002.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c84320002.reptg)
	e2:SetOperation(c84320002.repop)
	c:RegisterEffect(e2)
	--attack up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(84320002,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e3:SetCountLimit(1)
	--e3:SetCondition(c84320002.atkcon)
	e3:SetCost(c84320002.atkcost)
	e3:SetTarget(c84320002.atktg)
	e3:SetOperation(c84320002.atkop)
	c:RegisterEffect(e3)
end
function c84320002.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1234,1)
		tc=g:GetNext()
	end
end
function c84320002.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1234,1,REASON_EFFECT) end
	return Duel.SelectYesNo(tp,aux.Stringid(84320002,2))
end
function c84320002.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x1234,1,REASON_EFFECT)
end
function c84320002.atkcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c84320002.cfilter(c)
	return c:IsSetCard(0x7a0) or c:IsCode(59438930) or c:IsCode(55623480) and c:IsAbleToRemoveAsCost()
end
function c84320002.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1234,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1234,4,REASON_COST)
end
function c84320002.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
end
function c84320002.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(c84320002.atktg)
		e3:SetValue(1000)
		--e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function c84320002.atktg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7a0) or c:IsCode(59438930) or c:IsCode(55623480) 
end
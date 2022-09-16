--유키-회피하는 만남
function c84320006.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x7a0),nil,2)
	c:EnableReviveLimit()
	--counter
	 local e1=Effect.CreateEffect(c)
	 e1:SetDescription(aux.Stringid(84320006,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	 e1:SetOperation(c84320006.operation)
	 c:RegisterEffect(e1)
	 --destroy replace
	 local e2=Effect.CreateEffect(c)
	 e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	 e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	 e2:SetRange(LOCATION_MZONE)
	 e2:SetCode(EFFECT_DESTROY_REPLACE)
	 e2:SetTarget(c84320006.reptg)
	 e2:SetOperation(c84320006.repop)
	 c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c84320006.atkval)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(84320106,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(c84320006.tdcost)
	e4:SetTarget(c84320006.tdtg)
	e4:SetOperation(c84320006.tdop)
	c:RegisterEffect(e4)
end
function c84320006.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1234,1)
		tc=g:GetNext()
	end
end
function c84320006.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1234,1,REASON_EFFECT) end
	return Duel.SelectYesNo(tp,aux.Stringid(84320006,2))
end
function c84320006.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x1234,1,REASON_EFFECT)
end
function c84320006.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1234)*300
end
function c84320006.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1234,2,REASON_COST) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.RemoveCounter(tp,1,1,0x1234,2,REASON_COST)
end
function c84320006.tdfilter(c)
	return c:IsAbleToHand()
end
function c84320006.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c84320006.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c84320006.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectTarget(tp,c84320006.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c84320006.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,1,REASON_EFFECT)
	end
end

--ONESELF 비비드
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.con2)
	c:RegisterEffect(e2)
end
function s.con2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	end
end
function s.tfil1(c)
	return c:IsNegatable() and c:IsAbleToRemove() and c:IsSetCard(0xe75)
		and (c:IsLocation(LOCATION_FZONE) or c:GetSequence()<5)
end
function s.tfil2(c)
	return c:IsNegatable() and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IsExistingTarget(s.tfil1,tp,LOCATION_MZONE+LOCATION_FZONE,0,1,nil)
			and Duel.IsExistingTarget(s.tfil2,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
	end
	local g1=Duel.SelectTarget(tp,s.tfil1,tp,LOCATION_MZONE+LOCATION_FZONE,0,1,1,nil)
	local g2=Duel.SelectTarget(tp,s.tfil2,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,#g1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards(e)
	if #g==0 then
		return
	end
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		--Cannot activate its effect
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
	local sg=g:Filter(Card.IsControler,nil,tp)
	local og=g:Filter(Card.IsControler,nil,1-tp)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Remove(og,POS_FACEDOWN,REASON_EFFECT)
	else
		Duel.Remove(og,POS_FACEUP,REASON_EFFECT)
	end
end
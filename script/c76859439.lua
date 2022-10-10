--어떤 사랑의 형태
function c76859439.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,76859439+EFFECT_COUNT_CODE_OATH)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCost(c76859439.cost1)
	e1:SetTarget(c76859439.tar1)
	e1:SetOperation(c76859439.op1)
	c:RegisterEffect(e1)
end
function c76859439.cfil1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetLevel()==4 and c:IsRace(RACE_MACHINE) and c:IsAbleToGraveAsCost()
end
function c76859439.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859439.cfil1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c76859439.cfil1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c76859439.tfil1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetLevel()==4 and c:IsRace(RACE_FAIRY) and c:IsAbleToHand()
end
function c76859439.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859439.tfil1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_HAND)
end
function c76859439.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76859439.tfil1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
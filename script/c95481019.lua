--마그라프의 출사표
function c95481019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95481019)
	e1:SetTarget(c95481019.target)
	e1:SetOperation(c95481019.activate)
	c:RegisterEffect(e1)
end
function c95481019.filter(c)
	return c:IsSetCard(0xd53) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c95481019.filter2(c)
	return c:IsSetCard(0xd53) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not c:IsCode(95481019)
end
function c95481019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481019.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95481019.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95481019.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsPlayerCanDraw(tp,1) 
			and Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_PZONE,0,nil,0xd53)>=1
			and Duel.SelectYesNo(tp,aux.Stringid(95481019,0)) then
			Duel.BreakEffect()
			local sg=Duel.SelectMatchingCard(tp,c95481019.filter2,tp,LOCATION_DECK,0,1,1,nil)
				if sg:GetCount()>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end

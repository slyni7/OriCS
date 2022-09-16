--아니마기아스 코어
function c95481012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95481012+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c95481012.cost)
	e1:SetTarget(c95481012.target)
	e1:SetOperation(c95481012.activate)
	c:RegisterEffect(e1)
end
function c95481012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c95481012.filter1(c)
	return c:IsSetCard(0xd5e) and (c:IsAbleToGrave() or c:IsAbleToHand())
		and not c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER)
end
function c95481012.filter2(c)
	return c:IsSetCard(0xd5e) and (c:IsAbleToGrave() or c:IsAbleToHand()) 
		and c:IsType(TYPE_TUNER)
end
function c95481012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481012.filter1,tp,LOCATION_DECK,0,1,nil) 
		and Duel.IsExistingMatchingCard(c95481012.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c95481012.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c95481012.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c95481012.filter2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	Duel.ConfirmCards(1-tp,sg1)
	Duel.ShuffleDeck(tp)
	local cg=sg1:Select(1-tp,1,1,nil)
	local tc=cg:GetFirst()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	sg1:RemoveCard(tc)
	Duel.SendtoGrave(sg1,REASON_EFFECT)
end

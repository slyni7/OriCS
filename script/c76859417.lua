--인스톨 에타
function c76859417.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCost(c76859417.cost1)
	e1:SetTarget(c76859417.tg1)
	e1:SetOperation(c76859417.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCode(EVENT_SUMMON)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
	e2:SetCountLimit(1,76859417)
	e2:SetCondition(c76859417.con2)
	e2:SetCost(c76859417.cost2)
	e2:SetTarget(c76859417.tg2)
	e2:SetOperation(c76859417.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
end
function c76859417.cfilter1(c)
	return c:IsSetCard(0x2c1) and c:IsAbleToRemoveAsCost()
end
function c76859417.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c76859417.cfilter1,tp,LOCATION_HAND,0,1,nil)
	end
	local g=Duel.SelectMatchingCard(tp,c76859417.cfilter1,tp,LOCATION_HAND,0,1,1,nil)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c76859417.tfilter1(c,e,tp)
	return c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76859417.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c76859417.tfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76859417.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	local g=Duel.SelectMatchingCard(tp,c76859417.tfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c76859417.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) and Duel.GetCurrentChain()<1
end
function c76859417.cfilter2(c)
	return c:IsSetCard(0x2c1) and c:IsAbleToDeckAsCost()
end
function c76859417.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c76859417.cfilter2,tp,LOCATION_GRAVE,0,1,nil)
	end
	local g=Duel.SelectMatchingCard(tp,c76859417.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c76859417.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c76859417.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
end
--천명의 협곡
function c95480323.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95480323,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480323+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c95480323.cost)
	e1:SetTarget(c95480323.target1)
	e1:SetOperation(c95480323.activate1)
	c:RegisterEffect(e1)
	--Activate
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(95480323,1))
	e2:SetTarget(c95480323.target2)
	e2:SetOperation(c95480323.activate2)
	c:RegisterEffect(e2)
	--Activate
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(95480323,2))
	e3:SetTarget(c95480323.target3)
	e3:SetOperation(c95480323.activate3)
	c:RegisterEffect(e3)
end
function c95480323.cfilter(c,e,tp)
	return c:IsSetCard(0xd41) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c95480323.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480323.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c95480323.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c95480323.filter1(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonLocation()==LOCATION_HAND and c:IsAbleToHand()
end
function c95480323.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480323.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c95480323.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHNAD,g,g:GetCount(),0,0)
end
function c95480323.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c95480323.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c95480323.filter2(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonLocation()==LOCATION_GRAVE and c:IsAbleToGrave()
end
function c95480323.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480323.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c95480323.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c95480323.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c95480323.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c95480323.filter3(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonLocation()==LOCATION_GRAVE and c:IsAbleToDeck()
end
function c95480323.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480323.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c95480323.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c95480323.activate3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c95480323.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end

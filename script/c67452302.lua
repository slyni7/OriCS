--사이플루이드 트리엘
function c67452302.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PAY_LPCOST)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c67452302.con1)
	e1:SetTarget(c67452302.tar1)
	e1:SetOperation(c67452302.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1)
	e2:SetDescription(aux.Stringid(67452302,0))
	e2:SetCost(c67452302.cost2)
	e2:SetTarget(c67452302.tar2)
	e2:SetOperation(c67452302.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetCountLimit(1)
	e3:SetDescription(aux.Stringid(67452302,1))
	e3:SetCondition(c67452302.con3)
	e3:SetCost(c67452302.cost3)
	e3:SetTarget(c67452302.tar3)
	e3:SetOperation(c67452302.op3)
	c:RegisterEffect(e3)
end
function c67452302.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and Duel.GetLP(tp)<=c:GetAttack()
end
function c67452302.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67452302.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c67452302.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,700)
	else
		Duel.PayLPCost(tp,700)
	end
end
function c67452302.tfil21(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2db) and c:IsAbleToHand() and c:IsFaceup() and not c:IsCode(67452302)
end
function c67452302.tfil22(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x2db) and c:IsAbleToHand() and c:IsFaceup()
end
function c67452302.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IsExistingTarget(c67452302.tfil21,tp,LOCATION_REMOVED,0,1,nil)
			and Duel.IsExistingTarget(c67452302.tfil22,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c67452302.tfil21,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c67452302.tfil22,tp,LOCATION_REMOVED,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c67452302.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c67452302.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLP(tp)<=c:GetAttack()
end
function c67452302.cfil31(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2db) and c:IsAbleToRemoveAsCost()
end
function c67452302.cfil32(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x2db) and c:IsAbleToRemoveAsCost()
end
function c67452302.cfil33(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2db) and c:IsDiscardable()
end
function c67452302.cfil34(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x2db) and c:IsDiscardable()
end
function c67452302.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c67452302.cfil31,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(c67452302.cfil32,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(c67452302.cfil33,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(c67452302.cfil34,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c67452302.cfil31,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c67452302.cfil32,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g3=Duel.SelectMatchingCard(tp,c67452302.cfil33,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g4=Duel.SelectMatchingCard(tp,c67452302.cfil34,tp,LOCATION_HAND,0,1,1,nil)
	g3:Merge(g4)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.SendtoGrave(g3,REASON_COST+REASON_DISCARD)
end
function c67452302.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c67452302.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.Destroy(g,REASON_EFFECT)
end
--오카자키 유메미
--카드군 번호: 0xc97
function c81261000.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,"R",nil,aux.FilterBoolFunction(Card.IsSetCard,0xc97),aux.FilterBoolFunction(Card.IsSetCard,0xc97),aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT))
	
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81261000,2))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCost(c81261000.co1)
	e1:SetTarget(c81261000.tg1)
	e1:SetOperation(c81261000.op1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81261000,3))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c81261000.cn2)
	e2:SetCost(c81261000.co2)
	e2:SetTarget(c81261000.tg2)
	e2:SetOperation(c81261000.op2)
	c:RegisterEffect(e2)
	
	--상대 턴에도 발동
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(c81261000.tfil0)
	c:RegisterEffect(e3)
	
	--한데스
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81261000,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,81261000)
	e4:SetCondition(c81261000.cn4)
	e4:SetTarget(c81261000.tg4)
	e4:SetOperation(c81261000.op4)
	c:RegisterEffect(e4)
end
c81261000.CardType_Order=true

--제외
function c81261000.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c81261000.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81261000.cfil0,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81261000.cfil0,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81261000.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c81261000.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

--발동의 무효
function c81261000.cn2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c81261000.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81261000.cfil0,tp,LOCATION_GRAVE,0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81261000.cfil0,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81261000.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(e) then
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	end
end
function c81261000.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end

--상대 턴
function c81261000.tfil0(e,c)
	return c:GetType()&TYPE_SPELL+TYPE_QUICKPLAY==TYPE_SPELL+TYPE_QUICKPLAY and c:IsSetCard(0xc97)
end

--한데스
function c81261000.cn4(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_QUICKPLAY)
	and re:GetHandler():IsSetCard(0xc97)
end
function c81261000.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil,tp,POS_FACEUP)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c81261000.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil,tp,POS_FACEUP)
	if #g==0 then
		return
	end
	local rg=g:RandomSelect(tp,1)
	local tc=rg:GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT,true)
end

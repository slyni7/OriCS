--오덱시즈 백래쉬
--카드군 번호: 0xc91
function c81265060.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,81265060)
	e1:SetCondition(c81265060.cn1)
	e1:SetTarget(c81265060.tg1)
	e1:SetOperation(c81265060.op1)
	c:RegisterEffect(e1)
	
	--샐비지
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81265060,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,81265060)
	e2:SetCondition(c81265060.cn2)
	e2:SetTarget(c81265060.tg2)
	e2:SetOperation(c81265060.op2)
	c:RegisterEffect(e2)
end

--발동
function c81265060.cfilter(c)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_EXTRA) and c:IsSetCard(0xc91)
end
function c81265060.cn1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainNegatable(ev)
	and Duel.IsExistingMatchingCard(c81265060.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81265060.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c81265060.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
	end
end

--샐비지
function c81265060.cfilter1(c,tp)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_EXTRA) and c:IsSetCard(0xc91)
end
function c81265060.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81265060.cfilter1,1,nil,tp)
end
function c81265060.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsSSetable()
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c81265060.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetValue(LOCATION_DECKBOT)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e2)
	end
end



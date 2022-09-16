--오덱시즈 블레스
--카드군 번호: 0xc91
function c81265090.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81265090)
	e1:SetCost(c81265090.co1)
	e1:SetTarget(c81265090.tg1)
	e1:SetOperation(c81265090.op1)
	c:RegisterEffect(e1)
	
	--리쿠르트
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81265090,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81265090)
	e2:SetCost(c81265090.co2)
	e2:SetTarget(c81265090.tg2)
	e2:SetOperation(c81265090.op2)
	c:RegisterEffect(e2)
end

--내성
function c81265090.filter1(c)
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0xc91)
end
function c81265090.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81265090.filter1,tp,LOCATION_HAND,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c81265090.filter1,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c81265090.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xc91)
end
function c81265090.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81265090.filter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81265090.filter2,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81265090.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c81265090.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c81265090.val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c81265090.val(e,te)
	return te:GetOwner()~=e:GetOwner()
end

--리쿠르트
function c81265090.cfilter1(c)
	return c:IsDiscardable() and c:IsSetCard(0xc91)
end
function c81265090.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c81265090.cfilter1,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,c81265090.cfilter1,1,1,REASON_COST+REASON_DISCARD)
end
function c81265090.cfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc91)
end
function c81265090.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81265090.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c81265090.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81265090.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

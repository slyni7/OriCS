--오덱시즈 스펠
--카드군 번호: 0xc91
function c81265070.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c81265070.tg1)
	e1:SetOperation(c81265070.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(c81265070.filter0)
	c:RegisterEffect(e2)
	
	--스테이터스
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	
	--뵐러
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81265070,0))
	e5:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,81265070)
	e5:SetCondition(c81265070.cn5)
	e5:SetCost(c81265070.co5)
	e5:SetTarget(c81265070.tg5)
	e5:SetOperation(c81265070.op5)
	c:RegisterEffect(e5)
	--덱으로
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(81265070,1))
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,81265070)
	e6:SetCondition(c81265070.cn5)
	e6:SetCost(aux.bfgcost)
	e6:SetTarget(c81265070.tg6)
	e6:SetOperation(c81265070.op6)
	c:RegisterEffect(e6)
	
end

--발동
function c81265070.filter0(e,c)
	return c:IsSetCard(0xc91)
end
function c81265070.efilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc91)
end
function c81265070.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and c81265070.efilter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81265070.efilter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c81265070.efilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c81265070.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

--유발즉시효과
function c81265070.cn5(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2 and e:GetHandler():GetEquipTarget()
end
function c81265070.co5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	e:SetLabelObject(c:GetEquipTarget())
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c81265070.tfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c81265070.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c81265070.tfilter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81265070.tfilter,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c81265070.tfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c81265070.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=e:GetLabelObject()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		if ec and ec:IsLocation(LOCATION_MZONE) then
			Duel.BreakEffect()
			Duel.SendtoGrave(ec,REASON_EFFECT)
		end
	end
end

--덱으로
function c81265070.cfilter(c)
	return c:IsAbleToDeck() and c:IsSetCard(0xc91) and c:IsType(TYPE_MONSTER)
	and ( c:IsFaceup() or c:IsLocation(LOCATION_GRAVE) )
end
function c81265070.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81265070.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c81265070.op6(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81265070.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=g:Select(tp,1,5,nil)
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
		end
	end
end



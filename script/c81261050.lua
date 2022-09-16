--몽시공 - 유도 미사일
--카드군 번호: 0xc97
function c81261050.initial_effect(c)

	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0x10)
	e1:SetCountLimit(1,81261050)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c81261050.tg1)
	e1:SetOperation(c81261050.op1)
	c:RegisterEffect(e1)
	
	--발동시 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e2:SetCost(c81261050.co2)
	e2:SetTarget(c81261050.tg2)
	e2:SetOperation(c81261050.op2)
	c:RegisterEffect(e2)
end

--서치
function c81261050.tfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc97) and c:IsType(TYPE_MONSTER)
end
function c81261050.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81261050.tfil0,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end
function c81261050.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81261050.tfil0,tp,0x01,0,1,1,nil)
	if #g==0 then
		return
	end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT)
end

--발동시 효과
function c81261050.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc97)
end
function c81261050.cfil1(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0xc97)
end
function c81261050.trigger(c)
	return c:IsFaceup() and ( c:IsCode(81261000) or ( c:IsSetCard(0xc97) and c:IsType(TYPE_ORDER) ) )
end
function c81261050.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c81261050.cfil0,tp,0x02+0x10,0,1,c)
	local b2=Duel.IsExistingMatchingCard(c81261050.cfil1,tp,0x01+0x40,0,1,nil)
	local trigger=Duel.GetMatchingGroupCount(c81261050.trigger,tp,LOCATION_MZONE,0,nil)>0
	if chk==0 then
		return b1 or ( b2 and trigger )
	end
	local s=0
	if b1 and (not b2 or not trigger) then
		s=Duel.SelectOption(tp,aux.Stringid(81261050,2))
	end
	if not b1 and (b2 and trigger) then
		s=Duel.SelectOption(tp,aux.Stringid(81261050,3))+1
	end
	if b1 and (b2 and trigger) then
		s=Duel.SelectOption(tp,aux.Stringid(81261050,2),aux.Stringid(81261050,3))
	end
	e:SetLabel(s)
end
function c81261050.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,0,0x0c,1,nil)
	end
	local s=e:GetLabel()
	if s==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg1=Duel.SelectMatchingCard(tp,c81261050.cfil0,tp,0x02+0x10,0,1,1,e:GetHandler())
		Duel.Remove(rg1,POS_FACEUP,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local rg2=Duel.SelectMatchingCard(tp,c81261050.cfil1,tp,0x01+0x40,0,1,1,nil)
		Duel.SendtoGrave(rg2,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,0x0c,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c81261050.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=1 then
		local g=Duel.GetFieldGroup(tp,0,0x0c)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(81261050,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end

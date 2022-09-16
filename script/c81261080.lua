--몽시공 - 마술 과학
--카드군 번호: 0xc97
function c81261080.initial_effect(c)

	--발동시
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c81261080.co1)
	e1:SetTarget(c81261080.tg1)
	e1:SetOperation(c81261080.op1)
	c:RegisterEffect(e1)
	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,81261080)
	e2:SetCost(c81261080.co2)
	e2:SetTarget(c81261080.tg2)
	e2:SetOperation(c81261080.op2)
	c:RegisterEffect(e2)
end

--발동시
function c81261080.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc97)
end
function c81261080.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81261080.cfil0,tp,0x02+0x10,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81261080.cfil0,tp,0x02+0x10,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81261080.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField() and c81261080.tfil0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,0x0c,0x0c,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0x0c,0x0c,1,1,c)
end
function c81261080.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(81261080,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if tc:IsControler(tp) and tc:IsRace(RACE_CYBERSE) then
			local e2=e1:Clone()
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e2:SetValue(1)
			tc:RegisterEffect(e2)
		end
	end
end

--서치
function c81261080.cfil1(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc97)
end
function c81261080.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c81261080.cfil1,tp,0x10,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81261080.cfil1,tp,0x10,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81261080.tfil1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc97) and c:IsType(TYPE_SPELL) and not c:IsCode(81261080)
end
function c81261080.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81261080.tfil1,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end
function c81261080.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81261080.tfil1,tp,0x01,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--エクシーズ・リボーン
function c95480421.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480421+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c95480421.adtg)
	e1:SetOperation(c95480421.adop)
	c:RegisterEffect(e1)
end
function c95480421.cfilter(c)
	return c:IsSetCard(0xd45) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c95480421.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingMatchingCard(c95480421.cfilter,tp,LOCATION_DECK,0,1,nil)
	and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c95480421.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(cg,REASON_COST)
	e:SetLabelObject(cg:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c95480421.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local pc=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=pc:GetAttack()
		local def=pc:GetDefense()
		--atkdown
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		--defdown
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-def)
		tc:RegisterEffect(e2)
	end
end

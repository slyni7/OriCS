--MMJ house
function c81010110.initial_effect(c)
	--sendto hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81010110+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81010110.thco)
	e1:SetTarget(c81010110.thtg)
	e1:SetOperation(c81010110.thop)
	c:RegisterEffect(e1)
	--atk / def update
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010110,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c81010110.adco)
	e2:SetTarget(c81010110.adtg)
	e2:SetOperation(c81010110.adop)
	c:RegisterEffect(e2)
end

--sendto hand
function c81010110.thcofilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca1) and c:IsAbleToDeckAsCost()
end
function c81010110.thco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010110.thcofilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c81010110.thcofilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

function c81010110.filter(c,rc)
	return c:IsSetCard(0xca1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and not c:IsCode(rc)
end
function c81010110.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010110.filter,tp,LOCATION_DECK,0,2,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c81010110.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81010110.filter,tp,LOCATION_DECK,0,nil,e:GetLabel())
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg2=g:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	if sg1:GetCount()>1 then
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
end

--atk / def update
function c81010110.adfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca1) and c:IsType(TYPE_MONSTER)
end
function c81010110.adco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c81010110.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c81010110.adfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81010110.adfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81010110.adfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c81010110.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end

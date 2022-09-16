--MMJ Daichirei

function c81010190.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	
	--M / T destroy A
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81010190,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c81010190.fdscn1)
	e1:SetCost(c81010190.fdsco)
	e1:SetOperation(c81010190.fdsop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c81010190.fdscn2)
	c:RegisterEffect(e2)
	
	--sendto hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81010190,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(c81010190.thtg)
	e3:SetOperation(c81010190.thop)
	c:RegisterEffect(e3)
	
end

--M / T Destroy A
function c81010190.fdscn1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xca1)
end
function c81010190.fdscn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xca1)
end

function c81010190.fdsco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,2,REASON_COST)
	local ct=Duel.GetOperatedGroup()
	e:SetLabel(ct:GetCount())
end
function c81010190.fdsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=math.min(e:GetLabel())
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000*ct)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end



--sendto hand (e3)
function c81010190.thfilter(c)
	return c:IsSetCard(0xca1) and c:IsAbleToHand()
end
function c81010190.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81010190.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81010190.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81010190.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81010190.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
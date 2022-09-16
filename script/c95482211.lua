--리버런스 드바라팔라
function c95482211.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcGreater2(c,c95482211.fil1,LOCATION_HAND+LOCATION_GRAVE)
	--bfg
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,95482211)
	e2:SetTarget(c95482211.tg2)
	e2:SetOperation(c95482211.op2)
	c:RegisterEffect(e2)
end
function c95482211.fil1(c)
	return c:IsSetCard(0xd53)
end
function c95482211.fil2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(0xd53) and c:IsAbleToHand()
end
function c95482211.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c95482211.fil2(chkc) and e:GetHandler():IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(c95482211.fil2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c95482211.fil2,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c95482211.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
end

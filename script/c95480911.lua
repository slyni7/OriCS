--영매사 누에
function c95480911.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,95480911)
	e2:SetCondition(c95480911.thcon)
	e2:SetTarget(c95480911.thtg)
	e2:SetOperation(c95480911.thop)
	c:RegisterEffect(e2)
	--bounce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90307777,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95480989)
	e1:SetCondition(c95480911.descon)
	e1:SetTarget(c95480911.destg)
	e1:SetOperation(c95480911.desop)
	c:RegisterEffect(e1)
end
function c95480911.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xd42)
end
function c95480911.filter(c)
	return c:IsSetCard(0xd42) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c95480911.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c95480911.filter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95480911.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd42) and c:IsType(TYPE_PENDULUM) and not c:IsCode(95480911) and c:IsAbleToHand()
end
function c95480911.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if dg:GetCount()<2 then return end
	if Duel.Destroy(dg,REASON_EFFECT)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95480911.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(c95480911.sfilter,tp,LOCATION_EXTRA,0,nil)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(95480911,0)) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(1,0)
			e1:SetLabelObject(e)
			e1:SetTarget(c95480911.splimit)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e1:SetCode(EFFECT_CANNOT_SUMMON)
			Duel.RegisterEffect(e2,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local og=sg:Select(tp,1,1,nil)
			Duel.SendtoHand(og,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,og)
		end
	end
end
function c95480911.splimit(e,c)
	return not c:IsSetCard(0xd42) and c:IsLocation(LOCATION_EXTRA)
end
function c95480911.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c95480911.desfilter(c)
	return c:IsAbleToHand()
end
function c95480911.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c95480911.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
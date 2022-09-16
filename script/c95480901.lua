--영매사 료우
function c95480901.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,95480901)
	e2:SetCondition(c95480901.thcon)
	e2:SetTarget(c95480901.thtg)
	e2:SetOperation(c95480901.thop)
	c:RegisterEffect(e2)
	--ritual level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_RITUAL_LEVEL)
	e3:SetValue(c95480901.rlevel)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(95480901,ACTIVITY_SPSUMMON,c95480901.counterfilter)
	Duel.AddCustomActivityCounter(95480901,ACTIVITY_SUMMON,c95480901.counterfilter)
end
function c95480901.counterfilter(c)
	return c:IsSetCard(0xd42)
end
function c95480901.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x1d42) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c95480901.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xd42)
end
function c95480901.filter(c)
	return not c:IsCode(95480901) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd42) and c:IsAbleToHand()
end
function c95480901.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c95480901.filter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95480901.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd42) and c:IsType(TYPE_PENDULUM) and not c:IsCode(95480901) and c:IsAbleToHand()
end
function c95480901.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if dg:GetCount()<2 then return end
	if Duel.Destroy(dg,REASON_EFFECT)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c95480901.filter),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(c95480901.sfilter,tp,LOCATION_EXTRA,0,nil)
		if #sg>0 and Duel.GetCustomActivityCount(95480901,tp,ACTIVITY_SPSUMMON)==0 and Duel.SelectYesNo(tp,aux.Stringid(95480901,0)) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(1,0)
			e1:SetLabelObject(e)
			e1:SetTarget(c95480901.splimit)
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
function c95480901.splimit(e,c)
	return not c:IsSetCard(0xd42)
end

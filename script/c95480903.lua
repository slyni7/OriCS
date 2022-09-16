--영매사 하시히메
function c95480903.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69610326,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCountLimit(1,95480903)
	e1:SetCondition(c95480903.pccon)
	e1:SetTarget(c95480903.pctg)
	e1:SetOperation(c95480903.pcop)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,95480997)
	e3:SetTarget(c95480903.thtg)
	e3:SetOperation(c95480903.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c95480903.condition)
	c:RegisterEffect(e4)
end
function c95480903.pccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xd42)
end
function c95480903.pctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsFaceup() and chkc:IsControler(1-tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
	end
	local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	dg:Merge(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,3,0,0)
end
function c95480903.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if #dg<2 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	dg:AddCard(tc)
	if Duel.Destroy(dg,REASON_EFFECT)>0 then
		local sg=Duel.GetMatchingGroup(c95480903.filter,tp,LOCATION_EXTRA,0,nil)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(95480903,0)) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(1,0)
			e1:SetLabelObject(e)
			e1:SetTarget(c95480903.splimit)
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
function c95480903.splimit(e,c)
	return not c:IsSetCard(0xd42)
end
function c95480903.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c95480903.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd42) and c:IsType(TYPE_PENDULUM) and not c:IsCode(95480903) and c:IsAbleToHand()
end
function c95480903.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480903.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c95480903.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95480903.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


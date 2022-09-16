--
function c17300010.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy and set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,17300010)
	e1:SetCost(c17300010.cost1)
	e1:SetTarget(c17300010.tar1)
	e1:SetOperation(c17300010.op1)
	c:RegisterEffect(e1)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17300010,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,17299990)
	e1:SetTarget(c17300010.mattg)
	e1:SetOperation(c17300010.matop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(17300010,ACTIVITY_SPSUMMON,c17300010.counterfilter)
end
function c17300010.counterfilter(c)
	return c:IsSetCard(0x2d1)
end
function c17300010.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(17300010,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c17300010.splimit)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function c17300010.splimit(e,c)
	return not c:IsSetCard(0x2d1)
end
function c17300010.desfilter(c,tp)
	if c:IsFacedown() then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft==0 and c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 then
		return Duel.IsExistingMatchingCard(c17300010.filter,tp,LOCATION_DECK,0,1,nil,true)
	else
		return Duel.IsExistingMatchingCard(c17300010.filter,tp,LOCATION_DECK,0,1,nil,false)
	end
end
function c17300010.filter(c,ignore)
	return c:IsSetCard(0x2d1) and c:IsType(TYPE_SPELL) and c:IsSSetable(ignore)
end
function c17300010.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c17300010.desfilter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c17300010.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c17300010.desfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c17300010.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then
		return
	end
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c17300010.filter,tp,LOCATION_DECK,0,1,1,nil,false)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c17300010.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2d1) and c:IsType(TYPE_XYZ)
end
function c17300010.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c17300010.matfilter(chkc) end
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingTarget(c17300010.matfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c17300010.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c17300010.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
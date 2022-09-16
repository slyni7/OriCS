--영매사 자시키와라시
function c95480910.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59762399,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,95480910)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c95480910.spcon)
	e1:SetTarget(c95480910.sptg)
	e1:SetOperation(c95480910.spop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,95480990)
	e2:SetCondition(c95480910.pencon)
	e2:SetTarget(c95480910.pentg)
	e2:SetOperation(c95480910.penop)
	c:RegisterEffect(e2)
end
function c95480910.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xd42)
end
function c95480910.spfilter(c,e,tp)
	return not c:IsCode(95480910) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480910.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
	Duel.IsExistingMatchingCard(c95480910.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c95480910.spfilter2(c,e,tp)
	return not c:IsCode(95480910) and c:IsSetCard(0xd42) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480910.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if dg:GetCount()<2 then return end
	if Duel.Destroy(dg,REASON_EFFECT)~=2 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95480910.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local sg=Duel.GetMatchingGroup(c95480910.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp)
		if #sg>0 and Duel.GetLocationCountFromEx(tp)>0 and
			Duel.SelectYesNo(tp,aux.Stringid(95480910,0)) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(1,0)
			e1:SetLabelObject(e)
			e1:SetTarget(c95480910.splimit)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e1:SetCode(EFFECT_CANNOT_SUMMON)
			Duel.RegisterEffect(e2,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local og=sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(og,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c95480910.splimit(e,c)
	return not c:IsSetCard(0xd42) and c:IsLocation(LOCATION_EXTRA)
end
function c95480910.desfilter(c)
	return c:IsSetCard(0xd42)
end
function c95480910.penfilter(c)
	return c:IsSetCard(0xd42) and c:IsType(TYPE_PENDULUM) and not c:IsCode(95480910) and not c:IsForbidden()
end
function c95480910.pencon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c95480910.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c95480910.desfilter,tp,LOCATION_PZONE,0,nil)
	if chk==0 then return g:GetCount()>0
		and Duel.IsExistingMatchingCard(c95480910.penfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c95480910.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c95480910.desfilter,tp,LOCATION_PZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=Duel.SelectMatchingCard(tp,c95480910.penfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end

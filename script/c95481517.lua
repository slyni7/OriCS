--천승자의 계시
function c95481517.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c95481517.limcon)
	e2:SetOperation(c95481517.limop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_CHAIN_END)
	e4:SetOperation(c95481517.limop2)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(95481517,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c95481517.target)
	e5:SetOperation(c95481517.operation)
	c:RegisterEffect(e5)
end
function c95481517.limfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0xd55)
end
function c95481517.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95481517.limfilter,1,nil,tp)
end
function c95481517.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c95481517.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(95481517,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c95481517.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetFlagEffect(95481517)~=0 then
		Duel.SetChainLimitTillChainEnd(c95481517.chainlm)
	end
	e:GetHandler():ResetFlagEffect(95481517)
end
function c95481517.chainlm(e,rp,tp)
	return tp==rp or not e:IsActiveType(TYPE_MONSTER)
end


function c95481517.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd55) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95481517.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c95481517.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c95481517.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95481517.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c95481517.atktg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95481517.atktg(e,c)
	return not c:IsSetCard(0xd55)
end


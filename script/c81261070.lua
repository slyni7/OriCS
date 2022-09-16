--쁘띠 유메미
--카드군 번호: 0xc97
function c81261070.initial_effect(c)

	--카드명
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(81261000)
	c:RegisterEffect(e1)
	
	--유발
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,81261070)
	e2:SetCost(c81261070.co2)
	e2:SetTarget(c81261070.tg2)
	e2:SetOperation(c81261070.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(81261070,ACTIVITY_SPSUMMON,c81261070.ctfil)
end

--유발
function c81261070.ctfil(c)
	return c:GetSummonLocation()~=0x40 or c:IsType(TYPE_ORDER)
end

function c81261070.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c81261070.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetCustomActivityCount(81261070,tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingMatchingCard(c81261070.cfil0,tp,0x10,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81261070.cfil0,tp,0x10,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPSUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81261070.splim)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81261070.splim(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_ORDER) and c:IsLocation(LOCATION_EXTRA)
end
function c81261070.tfil0(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsType(TYPE_EFFECT) and c:IsFaceup() and not c:IsDisabled()
end
function c81261070.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81261070.tfil0,tp,0,LOCATION_MZONE,1,nil)
	end
end
function c81261070.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,c81261070.tfil0,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:Reset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
	end
end

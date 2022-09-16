--헬 슬레이
function c95480704.initial_effect(c)
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3117804,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetOperation(c95480704.posop)
	c:RegisterEffect(e1)
	--cannot be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c95480704.con)
	e2:SetTarget(c95480704.tglimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetCondition(c95480704.con)
	e3:SetValue(c95480704.atlimit)
	c:RegisterEffect(e3)
	--Halve ATK
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(36956512,0))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e5:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e5:SetCountLimit(1,95480704)
	e5:SetCondition(c95480704.atkcon)
	e5:SetCost(c95480704.atkcost)
	e5:SetTarget(c95480704.atktg)
	e5:SetOperation(c95480704.atkop)
	c:RegisterEffect(e5)
	--spsumon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(40908371,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetCountLimit(1)
	e6:SetTarget(c95480704.sptg)
	e6:SetOperation(c95480704.spop)
	c:RegisterEffect(e6)
end
function c95480704.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
function c95480704.con(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c95480704.atlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and not c:IsCode(95480704)
end
function c95480704.tglimit(e,c)
	return c~=e:GetHandler() and c:IsRace(RACE_ZOMBIE) and not c:IsCode(95480704)
end
function c95480704.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c95480704.cfilter(c)
	return c:IsRace(RACE_ZOMBIE) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c95480704.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c95480704.cfilter,1,e:GetHandler()) end
	local sg=Duel.SelectReleaseGroup(tp,c95480704.cfilter,1,1,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c95480704.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c95480704.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(math.ceil(tc:GetBaseAttack()/2))
		tc:RegisterEffect(e1)
	end
end

function c95480704.spfilter(c,e,tp)
	return c:IsSetCard(0xd4a) and c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480704.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c95480704.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c95480704.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95480704.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c95480704.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--비욘드 PDXX(PARADOXX) : 0
local m=112700071
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddBeyondProcedure(c,nil,"<",aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),"L")
	c:SetSPSummonOnce(m)
	--destroy all
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(cm.adval)
	c:RegisterEffect(e4)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e6)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCountLimit(1,m)
	e5:SetCondition(cm.spcon)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
end

cm.custom_type=CUSTOMTYPE_BEYOND

--beyond
function cm.lcheck(g)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end

--destroy all
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

--atk
function cm.filter(c)
	return c:IsFaceup() and c:GetCode()~=m and not c:IsHasEffect(m)
end
function cm.adval(e,c)
	local g=Duel.GetMatchingGroup(cm.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then 
		return 100
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		return val+100
	end
end

--special summon
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_BEYOND)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xe94) and not c:IsCode(m) and c:IsCustomType(CUSTOMTYPE_BEYOND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
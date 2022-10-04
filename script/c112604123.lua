--神威(ＫＡＭＵＩ)의 재기동
local m=112604123
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,m,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg2)
	e1:SetOperation(cm.spop2)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetCountLimit(1,{m,1},EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end

cm.listed_names={112604120}
cm.listed_series={0xe7a}
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,112604120,0xe7a0e90,TYPE_MONSTER+TYPE_EFFECT+TYPE_SYNCHRO,
			2000,2000,20,RACE_CYBERSE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,112604120,0xe7a0e90,TYPE_MONSTER+TYPE_EFFECT+TYPE_SYNCHRO,
			2000,2000,20,RACE_CYBERSE,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,112604120)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end

function cm.spcfilter(c,ft,tp)
	return (ft>0 or Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_RITUAL) or ((c:IsControler(tp) and c:GetSequence()<5) or 
		Duel.GetLocationCountFromEx(tp,tp,c,TYPE_RITUAL))) and c:IsRace(RACE_CYBERSE)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ft,tp) end
	local sg=Duel.SelectMatchingCard(tp,cm.spcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ft,tp)
	Duel.Release(sg,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xe7a) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function cm.spfilter2(c,e,tp)
	return c:IsSetCard(0xe7a) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false)
		and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
			or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		tc:CompleteProcedure()
	end
end
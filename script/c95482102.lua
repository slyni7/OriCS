--呪符竜
function c95482102.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,95482101,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),1,true,true)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30086349,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c95482102.tcon)
	e1:SetTarget(c95482102.ttg)
	e1:SetOperation(c95482102.top)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(61269611,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95482102)
	e2:SetCost(c95482102.spcost2)
	e2:SetTarget(c95482102.sptg2)
	e2:SetOperation(c95482102.spop2)
	c:RegisterEffect(e2)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c95482102.splimit)
	c:RegisterEffect(e0)
end
function c95482102.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsSetCard(0xd5a)
end
function c95482102.tcon(e,tp,eg,ep,ev,re,r,rp)
	return  bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c95482102.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,95482100,0,0x4011,400,1300,1,RACE_BEAST,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c95482102.top(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,95482100,0,0x4011,400,1300,1,RACE_BEAST,ATTRIBUTE_EARTH) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,95482100)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			token:RegisterEffect(e2,true)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			token:RegisterEffect(e3,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function c95482102.costfilter2(c,e,tp)
	return c:IsRace(RACE_BEAST) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingTarget(c95482102.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c95482102.spfilter(c,e,tp,mc)
	return c:IsRace(RACE_BEAST) and not c:IsOriginalCodeRule(mc:GetOriginalCodeRule()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c95482102.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c95482102.costfilter2,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,c95482102.costfilter2,1,1,nil,e,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.Release(g,REASON_COST)
end
function c95482102.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mc=e:GetLabelObject()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c95482102.spfilter(chkc,e,tp,mc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95482102.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c95482102.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
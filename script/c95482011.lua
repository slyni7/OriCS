--용화의 비전술
function c95482011.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29432356,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95482011+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c95482011.spcost)
	e1:SetTarget(c95482011.sptg)
	e1:SetOperation(c95482011.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(95482011,ACTIVITY_CHAIN,c95482011.chainfilter)
end
function c95482011.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0xd40) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY)
end
function c95482011.spcfilter(c,ft,tp)
	return ft>0 or (c:IsControler(tp) and c:GetSequence()<5) and c:IsRace(RACE_SPELLCASTER)
end
function c95482011.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c95482011.spcfilter,1,nil,ft,tp) 
		and Duel.GetCustomActivityCount(95482011,tp,ACTIVITY_CHAIN)<3  end
	local sg=Duel.SelectReleaseGroup(tp,c95482011.spcfilter,1,1,nil,ft,tp)
	Duel.Release(sg,REASON_COST)
end
function c95482011.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95482011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCustomActivityCount(95482011,tp,ACTIVITY_CHAIN)
	local loc=LOCATION_HAND
	if ct>0 then
		loc=loc+LOCATION_DECK
	end
	if ct>1 then
		loc=loc+LOCATION_EXTRA
	end
	if chk==0 then
		return Duel.IsExistingMatchingCard(c95482011.spfilter,tp,loc,0,1,nil,e,tp)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		ct=ct-1
	end
	if ct==0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	elseif ct==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	else 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
	end
end
function c95482011.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCustomActivityCount(95482011,tp,ACTIVITY_CHAIN)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		ct=ct-1
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local loc=LOCATION_HAND
	if ct>0 then
		loc=loc+LOCATION_DECK
	end
	if ct>1 then
		loc=loc+LOCATION_EXTRA
	end
	local g=Duel.SelectMatchingCard(tp,c95482011.spfilter,tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

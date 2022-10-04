--신을 만들어낸 자, 유카리(ONESELF)
local s,id=GetID()
function s.initial_effect(c)
	--Search Magical Dimension
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--ritual level
	Ritual.AddWholeLevelTribute(c,s.filter2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetCountLimit(1,{m,1},EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg2)
	e1:SetOperation(s.spop2)
	c:RegisterEffect(e1)
end
s.listed_names={28553439}
function s.filter2(c)
	return c:IsSetCard(0xe7a) and c:IsType(TYPE_RITUAL) and c:IsLevelBelow(19)
end
function s.thfilter(c)
	return (c:IsSetCard(0xe7a) or c:IsSetCard(0xe75)) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.costfilter(c)
	return c:IsSpell() and c:IsDiscardable() and c:IsSetCard(0xe7a)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,s.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0xe7a) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false)
		and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
			or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
			and c:IsLevelBelow(19)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		tc:CompleteProcedure()
		if c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		end
	end
end
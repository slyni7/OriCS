--플랑크 타임
local s,id=GetID()
function s.initial_effect(c)
	--Search Magical Dimension
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0xe74}
function s.tfil1(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0xe74)
end
function s.tfil2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsLevel(1) and c:IsAttack(1) and c:IsDefense(1)
end
function s.tfil3(c)
	return c:IsAbleToHand() and c:IsSetCard(0xe74)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.tfil1,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.tfil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b3=Duel.IsExistingMatchingCard(s.tfil3,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then
		return b1 or b2 or b3
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(s.tfil1,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.tfil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b3=Duel.IsExistingMatchingCard(s.tfil3,tp,LOCATION_GRAVE,0,1,nil)
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,2)},
		{b2,aux.Stringid(id,3)},
		{b3,aux.Stringid(id,4)})
	if op==1 then
		local g=Duel.SelectMatchingCard(tp,s.tfil1,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Summon(tp,tc,true,nil)
		end
	elseif op==2 then
		local g=Duel.SelectMatchingCard(tp,s.tfil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==3 then
		local g=Duel.SelectMatchingCard(tp,s.tfil3,tp,LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsRace,RACE_CYBERSE),tp,LOCATION_MZONE,0,nil)
	local sum=g:GetSum(Card.GetLevel)
	return sum>=1 and sum<=6
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
end

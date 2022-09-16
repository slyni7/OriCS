--蘇生紋章
function c95480815.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480815+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95480815.target)
	e1:SetOperation(c95480815.activate)
	c:RegisterEffect(e1)
end
function c95480815.filter(c,e,tp)
	return c:IsSetCard(0xd52) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480815.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c95480815.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c95480815.cfilter(c)
	return c:IsSetCard(0xd52) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c95480815.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95480815.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if Duel.IsExistingMatchingCard(c95480815.cfilter,tp,LOCATION_DECK,0,1,nil,tc:GetCode()) and Duel.SelectYesNo(tp,aux.Stringid(95480815,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,c95480815.cfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
			Duel.SendtoGrave(g2,REASON_EFFECT)
		end
	end
end

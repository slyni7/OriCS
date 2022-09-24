--ゼリークリーム
--CARD_BLUEEYES_SPIRIT	=59822133
function c112400023.initial_effect(c)
	--e1(spsummon)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112400023,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c112400023.condition)
	e1:SetTarget(c112400023.target)
	e1:SetOperation(c112400023.operation)
	c:RegisterEffect(e1)
end
c112400023.listed_series={0x4ec1}
--e1(spsummon)
function c112400023.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0x4ec1) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c112400023.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c112400023.cfilter,1,nil,tp)
end
function c112400023.spfilter(c,e,tp)
	return c:GetDefense()==1700 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c112400023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT or 59822133) then return false end
		if Duel.GetMZoneCount(tp)<2 then return false end
		return Duel.IsExistingMatchingCard(c112400023.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c112400023.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT or 59822133) then return end
	if Duel.GetMZoneCount(tp)<2 then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c112400023.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if #g>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		local tc=sg:GetFirst()
		while tc do
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
			end
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end

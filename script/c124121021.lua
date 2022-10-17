--샤프트밀의 견본마도서
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
s.listed_series={0x106e}
function s.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and rc:IsSetCard(0x106e)
		and not rc:IsCode(id))
end
function s.filter(c)
	return c:IsSetCard(0x106e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.ofil11(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGrave() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.ofil12(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsSetCard(0x106e) and c:IsType(TYPE_FUSION)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local dg=Duel.GetMatchingGroup(s.ofil11,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,tp)
		local sg=Duel.GetMatchingGroup(s.ofil12,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp)
		if Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)~=0
			and #dg>0 and #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local dc=dg:Select(tp,1,1,nil):GetFirst()
			if Duel.SendtoGrave(dc,REASON_EFFECT) and dc:IsLocation(LOCATION_GRAVE)
				and Duel.GetLocationCountFromEx(tp)>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sc=sg:Select(tp,1,1,nil)
				Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
				sc:CompleteProcedure()
			end
		end
	end
end

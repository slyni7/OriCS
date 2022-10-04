--플랑크 템퍼러쳐
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(s.tar2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
s.listed_series={0xe74}
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsRace,RACE_CYBERSE),tp,LOCATION_MZONE,0,nil)
	local sum=g:GetSum(Card.GetLevel)
	return sum>=1 and sum<=6
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimit(aux.FALSE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.filter(c,e,tp)
	return c:IsSetCard(0xe74) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(id)
end

function s.tfil2(c)
	return c:IsSetCard(0xe74) and not c:IsCode(id) and c:IsAbleToDeck() and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasableByEffect()
			and Duel.IsExistingMatchingCard(s.tfil2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Release(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,s.tfil2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,c)
		if #g>0 then
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.ConfirmDecktop(tp,#g)
			local tg=Duel.GetDecktopGroup(tp,#g)
			if #tg>0 then
				Duel.DisableShuffleCheck()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sc=tg:Select(tp,1,1,nil):GetFirst()
				if sc:IsAbleToHand() then
					Duel.SendtoHand(sc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sc)
					Duel.ShuffleHand(tp)
				else
					Duel.SendtoGrave(sc,REASON_RULE)
				end
			end
			if #tg>1 then
				Duel.SortDecktop(tp,tp,#tg-1)
				for i=1,#tg-1 do
					local dg=Duel.GetDecktopGroup(tp,1)
					Duel.MoveSequence(dg:GetFirst(),1)
				end
			end
		end
	end
end
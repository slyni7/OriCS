--소울 슬레이어의 군세
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tar1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SUMMON,s.counterfilter)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return c:IsSetCard(0x903)
end
function s.cfil1(c,tp)
	return (c:IsPublic() or c:IsFaceup()) and c:IsMonster() and c:IsSetCard(0x903) and c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingMatchingCard(s.cfil1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfil1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.splimit(e,c)
	return not c:IsSetCard(0x903)
end
function s.tfil1(c,e,tp)
	return c:IsSetCard(0x903) and 
		((c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
			or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()) or c:IsAbleToHand())
end
function s.tff1(c)
	return not c:IsAbleToHand() and c:IsMonster()
end
function s.tff2(c)
	return not c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.tfun1(sg,e,tp,mg)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local c1=sg:FilterCount(s.tff1,nil)
	local c2=sg:FilterCount(s.tff2,nil)
	local c3=sg:GetClassCount(Card.GetCode)
	return c3==2 and c1<=ft1 and c2<=ft2
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tfil1,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then
		return aux.SelectUnselectGroup(g,e,tp,2,2,s.tfun1,0)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tfil1,tp,LOCATION_DECK,0,nil,e,tp)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,s.tfun1,1,tp,HINTMSG_ATOHAND)
	if #sg~=2 then
		return
	end
	for tc in aux.Next(sg) do
		Duel.ConfirmCards(tp,tc)
		if tc:IsMonster() then
			if tc:IsAbleToHand() and (Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
				or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
				or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			else
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			end
		elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
			if tc:IsAbleToHand() and (Duel.GetLocationCount(tp,LOCATION_SZONE)<=0
				or not tc:IsSSetable()
				or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			else
				Duel.SSet(tp,tc)
			end
		end
	end
	Duel.ConfirmCards(1-tp,sg)
end
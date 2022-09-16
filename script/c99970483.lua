--[Insomnia]
local m=99970483
local cm=_G["c"..m]
function cm.initial_effect(c)

	--링크 소환
	RevLim(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xe0a),2,2)
	
	--죽음의 권능
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--특수 소환
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(spinel.delay)
	e3:SetCode(EVENT_DESTROYED)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	
	--불멸화
	local e2=Effect.CreateEffect(c)
	e2:SetD(m,3)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(spinel.delay)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)

end

--죽음의 권능
function cm.costfilter(c)
	return c:IsSetCard(0xe0a) and not c:IsPublic()
end
function cm.rcfilter(c,lg)
	return c:IsFaceup() and not c:IsRace(RACE_ZOMBIE) and lg:IsContains(c)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,nil)
		or not c:IsRace(RACE_SPELLCASTER) end
	if not c:IsRace(RACE_SPELLCASTER) and 
		(not Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,nil) or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_SPELLCASTER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	elseif Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	else return false
	end
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	local g=Duel.GetMatchingGroup(cm.rcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,lg)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_ZOMBIE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end

--특수 소환
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xe0a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetOperation(cm.desop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		tc:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

--불멸화
function cm.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_COST)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp) and re:IsHasType(0x7f0)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(RACE_ZOMBIE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,3,nil)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			Duel.ShuffleDeck(tg)
		end
	end
end

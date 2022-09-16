--[cb] 큐베사토,
local s,id=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e3:SetCost(s.rmcost)
	e3:SetTarget(s.eqtg)
	e3:SetOperation(s.eqop)
	c:RegisterEffect(e3)
end
function s.setfilter(c)
	return c:IsSetCard(0xe78) and c:IsAbleToDeck()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(s.setfilter,tp,LOCATION_GRAVE,0,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.setfilter,tp,LOCATION_GRAVE,0,1,7,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=#tg then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==#tg then
		Duel.BreakEffect()
		Duel.ConfirmDecktop(tp,ct)
		local g=Duel.GetDecktopGroup(tp,ct)
		if #g>0 then
			Duel.DisableShuffleCheck()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			if sc:IsAbleToHand() then
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
				Duel.ShuffleHand(tp)
				g:RemoveCard(sc)
				Duel.MoveToDeckBottom(g,tp)
				Duel.SortDeckbottom(tp,tp,#g)
			else
				Duel.SendtoGrave(sc,REASON_RULE)
			end
		end
	end
end

function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.filter(rc,e,tp)
	if (rc:IsType(TYPE_MONSTER) and
		((rc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0) or (not rc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)))
		and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then
		return true
	elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
		and rc:IsSSetable() then
		return true
	end
	return false
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=Duel.GetFirstTarget()
	if rc:IsRelateToEffect(e) then
		if (rc:IsType(TYPE_MONSTER) and
			((rc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0) or (not rc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)))
			and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then
			Duel.BreakEffect()
			Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,rc)
		elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and rc:IsSSetable() then
			Duel.BreakEffect()
			Duel.SSet(tp,rc)
		end
		Duel.BreakEffect()
		Duel.Recover(tp,555,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsSetCard(0xe78)
end
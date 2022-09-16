--인챈트릭스 난나
function c95481913.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,95481913)
	e1:SetTarget(c95481913.tar1)
	e1:SetOperation(c95481913.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetCountLimit(1,95481913)
	e2:SetCost(c95481913.cost2)
	e2:SetTarget(c95481913.tar2)
	e2:SetOperation(c95481913.op2)
	c:RegisterEffect(e2)
end
function c95481913.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup() and (c:IsControler(1-tp) or (c:IsSetCard(0xd49)))
end
function c95481913.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_REMOVED) and c95481913.spfilter(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c95481913.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) and
			Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95481913.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c95481913.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c95481913.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and
			c:IsAbleToRemoveAsCost()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c95481913.filter(c)
	return c:IsSetCard(0xd49) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
end
function c95481913.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(c95481913.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,3,c) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c95481913.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c95481913.filter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,c)
	if g:GetCount()<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,3,3,nil)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end

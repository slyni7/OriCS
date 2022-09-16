--파라바이오트 디저스터
function c95481211.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,95481205,aux.FilterBoolFunction(Card.IsFusionRace,RACE_INSECT),2,true,true)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95481211)
	e1:SetTarget(c95481211.drtg)
	e1:SetOperation(c95481211.drop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c95481211.negcon)
	e2:SetOperation(c95481211.negop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(30303854,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,95481289)
	e3:SetTarget(c95481211.sptg)
	e3:SetOperation(c95481211.spop)
	c:RegisterEffect(e3)
end
function c95481211.drfilter(c)
	return c:IsSetCard(0xd47) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND+LOCATION_GRAVE))
end
function c95481211.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481211.drfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c95481211.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c95481211.drfilter),p,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	Duel.ConfirmCards(1-tp,g)
	if Duel.SendtoDeck(g,1-tp,2,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ShuffleDeck(1-tp)
		tc:ReverseInDeck()
	end
end

function c95481211.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev)
		and e:GetHandler():GetFlagEffect(95481211)<=0
end
function c95481211.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(95481211,1)) then
		Duel.Hint(HINT_CARD,0,95481211)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c95481211.repop)
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		e:GetHandler():RegisterFlagEffect(95481211,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c95481211.filter(c)
	return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c95481211.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(95481211,2))
	local g1=Duel.SelectMatchingCard(tp,c95481211.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(95481211,2))
	local g2=Duel.SelectMatchingCard(1-tp,c95481211.filter,1-tp,LOCATION_DECK,0,1,1,nil)
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	if tc1 then
		Duel.SendtoHand(tc1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc1)
	end
	if tc2 then
		Duel.SendtoHand(tc2,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,tc2)
	end
end
function c95481211.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xd47) and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0
end
function c95481211.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c95481211.cfilter(chkc,tp) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c95481211.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c95481211.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,HINTMSG_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95481211.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,1-tp,2,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.ShuffleDeck(1-tp)
		tc:ReverseInDeck()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

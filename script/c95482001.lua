--신비의 비전술사 웨스트콧
function c95482001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86585274,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,95482001)
	e1:SetCost(c95482001.hspcost)
	e1:SetTarget(c95482001.hsptg)
	e1:SetOperation(c95482001.hspop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95482001,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c95482001.thcon)
	e2:SetTarget(c95482001.thtg)
	e2:SetOperation(c95482001.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetTarget(c95482001.thtg2)
	e3:SetOperation(c95482001.thop2)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(23064604,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,95482001)
	e4:SetCondition(c95482001.spcon)
	e4:SetCost(c95482001.spcost)
	e4:SetTarget(c95482001.sptg)
	e4:SetOperation(c95482001.spop)
	c:RegisterEffect(e4)
end
function c95482001.cffilter(c)
	return c:IsSetCard(0xd40) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function c95482001.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95482001.cffilter,tp,LOCATION_HAND,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c95482001.cffilter,tp,LOCATION_HAND,0,3,3,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c95482001.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,1,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c95482001.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
end


function c95482001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c95482001.thfilter(c)
	return c:IsSetCard(0xd40) and c:IsType(TYPE_SPELL) and c:IsAbleToDeck() and not c:IsPublic()
end
function c95482001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c95482001.thfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c95482001.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,c95482001.thfilter,p,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Draw(p,ct+1,REASON_EFFECT)
	end
end
function c95482001.filter(c)
	return c:IsSetCard(0xd40) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c95482001.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c95482001.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95482001.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95482001.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c95482001.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c95482001.cfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsDiscardable()
end
function c95482001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95482001.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c95482001.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c95482001.spfilter(c)
	return c:IsSetCard(0xd40) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c95482001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c95482001.spfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95482001.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c95482001.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c95482001.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nli,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

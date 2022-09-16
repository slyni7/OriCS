--알피스트 콜링
function c95482121.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c95482121.tg)
	e1:SetOperation(c95482121.op)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c95482121.thcon)
	e2:SetCost(c95482121.thcost)
	e2:SetTarget(c95482121.thtg)
	e2:SetOperation(c95482121.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CUSTOM+95482121)
	e3:SetCondition(c95482121.thcon2)
	c:RegisterEffect(e3)
end
function c95482121.filter(c)
	return c:IsSetCard(0xd5a) and c:IsFaceup()
end
function c95482121.filter1(c)
	return c:IsCode(95482101) and c:IsAbleToHand()
end
function c95482121.filter2(c)
	return (c:IsCode(95482101) or (c:IsSetCard(0xd5a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(95482121))) and c:IsAbleToHand()
end
function c95482121.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsExistingMatchingCard(c95482121.filter,tp,LOCATION_MZONE,0,1,nil) then
			return Duel.IsExistingMatchingCard(c95482121.filter1,tp,LOCATION_DECK,0,1,nil) end
		return Duel.IsExistingMatchingCard(c95482121.filter2,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95482121.op(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if not Duel.IsExistingMatchingCard(c95482121.filter,tp,LOCATION_MZONE,0,1,nil) then
		g=Duel.SelectMatchingCard(tp,c95482121.filter1,tp,LOCATION_DECK,0,1,1,nil)
	else g=Duel.SelectMatchingCard(tp,c95482121.filter2,tp,LOCATION_DECK,0,1,1,nil) end
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c95482121.thcon(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	return rp==tp and de and dp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and e:GetHandler()==re:GetHandler() and e:GetHandler():GetReasonEffect()==de
end
function c95482121.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==re:GetHandler() and c:GetReasonEffect()==nil
end

function c95482121.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c95482121.spfilter(c,e,tp)
	return c:IsSetCard(0xd5a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95482121.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c95482121.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
end
function c95482121.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95482121.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
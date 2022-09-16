--神の居城－ヴァルハラ
function c95480319.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480319+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95480319.target)
	e1:SetOperation(c95480319.activate)
	c:RegisterEffect(e1)
	--xyz effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1)
	e2:SetTarget(c95480319.xctg)
	e2:SetOperation(c95480319.xcop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9659580,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c95480319.thtg)
	e3:SetOperation(c95480319.thop)
	c:RegisterEffect(e3)
end
function c95480319.filter(c)
	return c:IsSetCard(0xd41) and c:IsAbleToHand() and not c:IsCode(95480319)
end
function c95480319.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480319.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95480319.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95480319.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c95480319.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1d41)
end
function c95480319.xctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c95480319.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c95480319.xcop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c95480319.mfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,sg:GetFirst(),nil,mg)
	end
end

function c95480319.thfilter(c)
	return c:IsSetCard(0xd41) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and not c:IsCode(95480319)
end
function c95480319.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480319.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95480319.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95480319.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
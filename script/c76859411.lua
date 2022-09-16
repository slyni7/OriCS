--인스톨 제타
function c76859411.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2c1),nil,1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(76859411,0))
	e1:SetCountLimit(1,76859411)
	e1:SetCost(c76859411.cost1)
	e1:SetTarget(c76859411.tg1)
	e1:SetOperation(c76859411.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(76859411,1))
	e2:SetCountLimit(1,76859412)
	e2:SetCost(c76859411.cost1)
	e2:SetTarget(c76859411.tg2)
	e2:SetOperation(c76859411.op2)
	c:RegisterEffect(e2)
	if not c76859411.global_check then
		c76859411.global_check=true
		c76859411[0]=true
		c76859411[1]=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c76859411.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c76859411.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c76859411.gop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsSetCard(0x2c1) then
			c76859411[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c76859411.gop2(e,tp,eg,ep,ev,re,r,rp)
	c76859411[0]=true
	c76859411[1]=true
end
function c76859411.cfilter1(c)
	return c:IsSetCard(0x2c1) and c:IsAbleToRemoveAsCost() and not c:IsCode(76859411)
end
function c76859411.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c76859411[tp]
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c76859411.tfilter11)
	Duel.RegisterEffect(e1,tp)
end
function c76859411.tfilter11(e,c)
	return not c:IsSetCard(0x2c1)
end
function c76859411.tfilter1(c)
	return c:IsSetCard(0x2c1) and c:IsAbleToHand() and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function c76859411.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859411.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c76859411.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c76859411.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()<2 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,2,2,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
function c76859411.tfilter2(c,e,tp)
	return c:IsSetCard(0x2c1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(76859411) and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function c76859411.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(c76859411.tfilter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c76859411.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then
		return
	end
	local g=Duel.GetMatchingGroup(c76859411.tfilter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if g:GetCount()<2 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,2,2,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
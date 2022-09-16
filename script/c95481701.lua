--플로리아 피치
function c95481701.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88264978,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,95481701)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c95481701.con1)
	e1:SetCost(c95481701.cost)
	e1:SetTarget(c95481701.tg1)
	e1:SetOperation(c95481701.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c95481701.con2)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(57030525,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,95481701)
	e3:SetTarget(c95481701.tg3)
	e3:SetOperation(c95481701.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c95481701.con4)
	c:RegisterEffect(e4)
	if not c95481701.bloominus_effect then
		c95481701.bloominus_effect={}
	end
	c95481701.bloominus_effect[c]=e1
end
function c95481701.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,95481709)
end
function c95481701.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,95481709)
end
function c95481701.cfil1(c)
	return c:IsRace(RACE_PLANT) and c:IsDiscardable()
end
function c95481701.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481701.cfil1,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c95481701.cfil1,1,1,REASON_COST+REASON_DISCARD)
end
function c95481701.fil1(c,e,tp)
	return c:IsSetCard(0xd50) and not c:IsCode(95481701) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95481701.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c95481701.fil1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c95481701.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c95481701.fil1),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c95481701.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and e:GetHandler():IsPreviousLocation(LOCATION_HAND) and re:IsActivated()
		and re:IsActiveType(TYPE_MONSTER) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)&RACE_PLANT>0
end
function c95481701.fil2(c)
	return c:IsSetCard(0xd50) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToHand() and not c:IsCode(95481701)
end
function c95481701.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetControler()==tp and c95481701.fil2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95481701.fil2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c95481701.fil2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c95481701.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end



--천명신 이라
function c95480308.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c95480308.target)
	e1:SetOperation(c95480308.activate)
	c:RegisterEffect(e1)
	--monster effects
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95480303,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,95480308)
	e2:SetCondition(c95480308.con)
	e2:SetCost(c95480308.cost)
	e2:SetTarget(c95480308.thtg)
	e2:SetOperation(c95480308.thop)
	c:RegisterEffect(e2)
end
function c95480308.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,95480308,0,0x21,1900,1400,6,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c95480308.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,95480308,0,0x21,1900,1400,6,RACE_FIEND,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,1,tp,tp,true,false,POS_FACEUP)
end
function c95480308.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c95480308.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c95480308.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480308.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c95480308.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c95480308.thfilter(c,tp)
	return c:IsSetCard(0x1d41) and c:IsSSetable()
end
function c95480308.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c95480308.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c95480308.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c95480308.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
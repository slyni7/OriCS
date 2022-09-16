--이레귤러: 어센션
function c95480613.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(Card.IsSetCard,0xd57),aux.Tuner(Card.IsSetCard,0xd57),nil,aux.NonTuner(Card.IsRace,RACE_PSYCHO),1,1)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,95480613)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c95480613.condition)
	e1:SetCost(c95480613.cost)
	e1:SetTarget(c95480613.target)
	e1:SetOperation(c95480613.activate)
	c:RegisterEffect(e1)
end
function c95480613.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c95480613.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c95480613.filter(c,type)
	return c:IsType(type) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemove()
end
function c95480613.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local type=bit.band(eg:GetFirst():GetType(),0x7)
	local g=Duel.GetMatchingGroup(c95480613.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,type)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c95480613.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480613.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	local type=bit.band(eg:GetFirst():GetType(),0x7)
	local g1=Duel.GetMatchingGroup(c95480613.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,type)
	if Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g2=Duel.GetMatchingGroup(c95480613.spfilter,tp,LOCATION_REMOVED,0,e:GetHandler(),e,tp)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95480613,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g2:Select(tp,1,1,nil)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
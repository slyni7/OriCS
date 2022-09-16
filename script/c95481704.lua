--플로리아 데이지
function c95481704.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88264978,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,95481704)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c95481704.con1)
	e1:SetCost(c95481704.cost1)
	e1:SetTarget(c95481704.tg1)
	e1:SetOperation(c95481704.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c95481704.con2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_HAND)
	e3:SetOperation(c95481704.op3)
	c:RegisterEffect(e3)
	if not c95481704.bloominus_effect then
		c95481704.bloominus_effect={}
	end
	c95481704.bloominus_effect[c]=e1
end
function c95481704.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,95481709)
end
function c95481704.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,95481709)
end
function c95481704.cfil1(c)
	return c:IsRace(RACE_PLANT) and c:IsDiscardable()
end
function c95481704.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481704.cfil1,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c95481704.cfil1,1,1,REASON_COST+REASON_DISCARD)
end
function c95481704.fil1(c,e,tp)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function c95481704.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481704.fil1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end
function c95481704.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c95481704.fil1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end

function c95481704.fil3(c,tp)
	return c:IsSetCard(0xd50) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c95481704.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g<1 then
		return
	end
	local tg=g:Filter(c95481704.fil3,nil,tp)
	if #tg>0 and c:IsAbleToRemove() and Duel.IsChainDisablable(ev) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		if Duel.NegateEffect(ev) then
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		end
	end
end

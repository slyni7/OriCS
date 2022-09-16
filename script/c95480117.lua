--천명신성 에퀴녹스
function c95480117.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67007102,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480117)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c95480117.target)
	e1:SetOperation(c95480117.activate)
	c:RegisterEffect(e1)
end

function c95480117.atkfilter(c)
	return aux.disfilter1(c)
end
function c95480117.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,95480117,0,TYPES_NORMAL_TRAP_MONSTER,2100,1900,6,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c95480117.filter(c)
	return c:IsFaceup() and (c:IsLinkState() or c:IsSetCard(0xd41))
end
function c95480117.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,95480117,0,TYPES_NORMAL_TRAP_MONSTER,2100,1900,6,RACE_FIEND,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(c95480117.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c95480117.atkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(95480117,2)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c95480117.atkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=e1:Clone()
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				tc:RegisterEffect(e3)
			end
			Duel.AdjustInstantly(tc)
		end
	end
end
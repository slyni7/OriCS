--엔포서즈 페어
function c95481911.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c95481911.target)
	e1:SetOperation(c95481911.activate)
	c:RegisterEffect(e1)
end
function c95481911.atkfilter(c,tp)
	local g=c:GetMaterial()
	return c:IsSetCard(0xd49) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and g and g:IsExists(c95481911.atkfilter2,1,nil,tp)
end
function c95481911.atkfilter2(c,tp)
	return c:GetOwner()==1-tp
end
function c95481911.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95481911.cfilter(c,tp)
	return c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c)>0 and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd49)
end
function c95481911.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c95481911.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) and Duel.IsExistingMatchingCard(c95481911.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,tp)
	local b2=Duel.IsExistingMatchingCard(c95481911.atkfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	local b3=Duel.GetFlagEffect(tp,95481911)==0
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(95481911,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(95481911,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(95481911,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE,nil,1,0,0)
	end
end
function c95481911.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		if not Duel.IsExistingMatchingCard(c95481911.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,tp) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,c95481911.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
		local sc=tg:GetFirst()
		if sc and Duel.SendtoGrave(sc,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_GRAVE) then
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c95481911.spfilter),tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
			local tc=g:GetFirst()
			if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
		Duel.SpecialSummonComplete()
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c95481911.atkfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ATTACK_ANNOUNCE)
			e1:SetOperation(c95481911.downop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EVENT_BE_BATTLE_TARGET)
			tc:RegisterEffect(e2)
		end
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c95481911.chainop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,95481911,RESET_PHASE+PHASE_END,0,1)
	end
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c95481911.downop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local atk=bc:GetBaseAttack()
	if bc and bc:IsType(TYPE_MONSTER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		e1:SetValue(-atk)
		bc:RegisterEffect(e1)
	end
end
function c95481911.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0xd49) and re:IsActiveType(TYPE_MONSTER) and ep==tp then
		Duel.SetChainLimit(c95481911.chainlm)
	end
end
function c95481911.chainlm(e,rp,tp)
	return tp==rp
end
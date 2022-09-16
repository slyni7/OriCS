--에퀴녹스 스트라이크
function c95480114.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,95480114+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c95480114.cost)
	e1:SetTarget(c95480114.target)
	e1:SetOperation(c95480114.activate)
	c:RegisterEffect(e1)
	if not c95480114.global_check then
		c95480114.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(c95480114.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c95480114.mtfilter1(c)
	return c:IsSetCard(0xd5f) and c:IsType(TYPE_MONSTER)
end
function c95480114.mtfilter2(c)
	return c:IsFusionSetCard(0xd5f) and c:IsFusionType(TYPE_MONSTER)
end
function c95480114.mtfilter3(c)
	return c:IsSetCard(0xd5f) and c:IsSynchroType(TYPE_MONSTER)
end
function c95480114.mtfilter4(c)
	return c:IsSetCard(0xd5f) and c:IsXyzType(TYPE_MONSTER)
end
function c95480114.mtfilter5(c)
	return c:IsSetCard(0xd5f) and c:IsLinkType(TYPE_MONSTER)
end
function c95480114.valcheck(e,c)
	local g=c:GetMaterial()
	if c:IsType(TYPE_RITUAL) and g:IsExists(c95480114.mtfilter1,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_FUSION) and g:IsExists(c95480114.mtfilter2,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_SYNCHRO) and g:IsExists(c95480114.mtfilter3,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_XYZ) and g:IsExists(c95480114.mtfilter4,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_LINK) and g:IsExists(c95480114.mtfilter5,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	end
end
function c95480114.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0xd5f) 
end
function c95480114.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480114.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c95480114.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c95480114.actfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(95480000)~=0
end
function c95480114.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c95480114.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c95480114.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c95480114.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
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
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e3:SetTarget(c95480114.distg)
			e3:SetLabelObject(tc)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetCode(EVENT_CHAIN_SOLVING)
			e4:SetCondition(c95480114.discon)
			e4:SetOperation(c95480114.disop)
			e4:SetLabelObject(tc)
			e4:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e4,tp)
		end
	end
end
function c95480114.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c95480114.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c95480114.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
--환류의 비전술
function c95482010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95482010+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c95482010.cost)
	e1:SetOperation(c95482010.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(95482010,ACTIVITY_CHAIN,c95482010.chainfilter)
end
function c95482010.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0xd40) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY)
end
function c95482010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetCustomActivityCount(95482010,tp,ACTIVITY_CHAIN)<3 end
end
function c95482010.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c95482010.damcon1)
	e1:SetOperation(c95482010.damop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c95482010.regcon)
	e2:SetOperation(c95482010.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c95482010.damcon2)
	e3:SetOperation(c95482010.damop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local ct=Duel.GetCustomActivityCount(95482010,tp,ACTIVITY_CHAIN)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		ct=ct-1
	end
	if ct>=1 or ct>=2 then
		if ct>=1 and Duel.SelectYesNo(tp,aux.Stringid(95482010,1)) then
			Duel.BreakEffect()
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e4:SetProperty(EFFECT_FLAG_DELAY)
			e4:SetCode(EVENT_TO_HAND)
			e4:SetCondition(c95482010.rmcon1)
			e4:SetOperation(c95482010.rmop1)
			e4:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e4,tp)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e5:SetCode(EVENT_TO_HAND)
			e5:SetCondition(c95482010.regcon2)
			e5:SetOperation(c95482010.regop2)
			e5:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e5,tp)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e6:SetCode(EVENT_CHAIN_SOLVED)
			e6:SetCondition(c95482010.rmcon2)
			e6:SetOperation(c95482010.rmop2)
			e6:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e6,tp)
		end
		if ct>=2 and Duel.SelectYesNo(tp,aux.Stringid(95482010,2)) then
			Duel.BreakEffect()
			local e7=Effect.CreateEffect(c)
			e7:SetType(EFFECT_TYPE_FIELD)
			e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
			e7:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e7:SetTargetRange(0xfe,0xff)
			e7:SetValue(LOCATION_REMOVED)
			e7:SetTarget(c95482010.rmtg)
			e7:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e7,tp)
		end
	end
end
function c95482010.filter(c,sp)
	return c:GetSummonPlayer()==sp
end
function c95482010.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95482010.filter,1,nil,1-tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c95482010.damop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,300,REASON_EFFECT)
end
function c95482010.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95482010.filter,1,nil,1-tp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c95482010.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,95482090,RESET_CHAIN,0,1)
end
function c95482010.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,95482090)>0
end
function c95482010.damop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,95482090)
	Duel.ResetFlagEffect(tp,95482090)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c95482010.cfilter(c,tp)
	return c:IsControler(1-tp) and not c:IsReason(REASON_DRAW) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function c95482010.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95482010.cfilter,1,nil,tp) 
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c95482010.rmop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,95482010)
	local tg=Duel.GetDecktopGroup(1-tp,3)
	Duel.DisableShuffleCheck()
	Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
end
function c95482010.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95482010.cfilter,1,nil,tp) and Duel.GetFlagEffect(tp,95482089)==0 
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c95482010.regop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,95482089,RESET_CHAIN,0,1)
end
function c95482010.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,95482089)>0
end
function c95482010.rmop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,95482089)
	Duel.Hint(HINT_CARD,0,95482010)
	local tg=Duel.GetDecktopGroup(1-tp,3)
	Duel.DisableShuffleCheck()
	Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
end
function c95482010.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
--봉마의 비전술
function c95482012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95482012+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c95482012.cost)
	e1:SetTarget(c95482012.target)
	e1:SetOperation(c95482012.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(95482012,ACTIVITY_CHAIN,c95482012.chainfilter)
end
function c95482012.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0xd40) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY)
end
function c95482012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetCustomActivityCount(95482012,tp,ACTIVITY_CHAIN)<3 end
end
function c95482012.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c95482012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c95482012.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95482012.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c95482012.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local ct=Duel.GetCustomActivityCount(95482012,tp,ACTIVITY_CHAIN)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		ct=ct-1
	end
	if ct>=1 then
		e:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	end
end
function c95482012.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local ct=Duel.GetCustomActivityCount(95482012,tp,ACTIVITY_CHAIN)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			ct=ct-1
		end
		if (ct>=1 and tc:GetAttack()>0) or (ct>=2 and g:GetCount()>0) then
			if ct>=1 and tc:GetAttack()>0 and Duel.SelectYesNo(tp,aux.Stringid(95482012,1)) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_SET_ATTACK_FINAL)
				e3:SetValue(0)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
				local e4=e3:Clone()
				e4:SetCode(EFFECT_SET_ATTACK_DEFENSE)
				tc:RegisterEffect(e4)
			end
			if ct>=2 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95482012,2)) then
				local e5=Effect.CreateEffect(c)
				e5:SetType(EFFECT_TYPE_FIELD)
				e5:SetCode(EFFECT_DISABLE)
				e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
				e5:SetTarget(c95482012.distg)
				e5:SetLabelObject(tc)
				e5:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e5,tp)
				local e6=Effect.CreateEffect(c)
				e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e6:SetCode(EVENT_CHAIN_SOLVING)
				e6:SetCondition(c95482012.discon)
				e6:SetOperation(c95482012.disop)
				e6:SetLabelObject(tc)
				e6:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e6,tp)
			end
		end
	end
end
function c95482012.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c95482012.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c95482012.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

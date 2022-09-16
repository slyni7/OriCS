--[Insomnia]
local m=99970489
local cm=_G["c"..m]
function cm.initial_effect(c)

	--공격 무효
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_ATTACK)
	WriteEff(e1,1,"NCO")
	c:RegisterEffect(e1)
	
	--공수 증가
	local e2=MakeEff(c,"Qo","G")
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCost(aux.bfgcost)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
end

--공격 무효
function cm.cfilter(c)
	return c:IsSetCard(0xe0a) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToGraveAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	e:SetLabel(tc:GetAttack())
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE))
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabel()
	local ac=Duel.GetAttacker()
	if ac and ac:IsAttackBelow(atk) then
		Duel.NegateAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(atk)
		e1:SetCondition(cm.discon)
		e1:SetOperation(cm.disop)
		Duel.RegisterEffect(e1,tp)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(2)
		e1:SetLabel(atk)
		e1:SetCondition(cm.discon)
		e1:SetOperation(cm.disop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsAttackBelow(e:GetLabel())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateAttack()
end

--공수 증가
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0a)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end

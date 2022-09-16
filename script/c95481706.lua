--플로리아 카네이션
function c95481706.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88264978,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,95481706)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c95481706.con1)
	e1:SetCost(c95481706.cost1)
	e1:SetTarget(c95481706.tg1)
	e1:SetOperation(c95481706.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c95481706.con2)
	c:RegisterEffect(e2)
	--atkdown
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26914168,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,95481706)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetCondition(c95481706.con3)
	e3:SetCost(c95481706.cost3)
	e3:SetTarget(c95481706.tg3)
	e3:SetOperation(c95481706.op3)
	c:RegisterEffect(e3)
	if not c95481706.bloominus_effect then
		c95481706.bloominus_effect={}
	end
	c95481706.bloominus_effect[c]=e1
end

function c95481706.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,95481709)
end
function c95481706.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,95481709)
end
function c95481706.cfil1(c)
	return c:IsRace(RACE_PLANT) and c:IsDiscardable()
end
function c95481706.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481706.cfil1,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c95481706.cfil1,1,1,REASON_COST+REASON_DISCARD)
end
function c95481706.fil1(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c95481706.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481706.fil1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c95481706.fil1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c95481706.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c95481706.fil1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function c95481706.con3(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if not a:IsControler(tp) then a,d=d,a end
	e:SetLabelObject(d)
	return a:IsControler(tp) and a:IsFaceup() and a:IsRace(RACE_PLANT) and d:IsControler(1-tp) and d:IsFaceup() and d:IsRelateToBattle()
end
function c95481706.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c95481706.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=e:GetLabelObject()
	if chk==0 then return d end
	Duel.SetTargetCard(d)
end
function c95481706.op3(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetFirstTarget()
	if not (d:IsRelateToBattle() and d:IsFaceup() and d:IsControler(1-tp)) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(-d:GetAttack())
	d:RegisterEffect(e1)
end

--몽시공의 탐구자
--카드군 번호: 0xc97
local m=81261110
local cm=_G["c"..m]
function cm.initial_effect(c)

	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.filter1)
	
	--공격력 증가
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetCost(cm.co1)
	e1:SetOperation(cm.op1)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	c:RegisterEffect(e1)
	
	--회수
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.cn2)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--소환 제약(0x40, TYPE_ORDER)
function cm.filter1(c)
	return c:GetSummonLocation()~=0x40 or c:IsType(TYPE_ORDER)
end

--데미지 스텝
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if ph~=PHASE_DAMAGE or Duel.IsDamageCalculated() then
		return false
	end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return ( a:IsControler(tp) and a:IsRelateToBattle())
	or (d and d:IsControler(tp) and d:IsRelateToBattle())
end
function cm.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(0x1)
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost() and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0
	end
	local g=Duel.GetMatchingGroup(cm.cfil0,tp,0x10,0,c)
	local gc=Group.CreateGroup()
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,2,nil)
		if #sg>0 then gc:Merge(sg) end
	end
	gc:Merge(c)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	e:SetLabel(#gc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_ORDER) and c:IsLocation(0x40)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if Duel.GetTurnPlayer()~=tp then a=Duel.GetAttackTarget() end
	if not a:IsRelateToBattle() or a:IsFacedown() then
		return
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(e:GetLabel()*1100)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	a:RegisterEffect(e1)
end

--회수
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(0x10) and r==REASON_ORDER
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.tfil0(c)
	return c:IsAbleToHand() and (c:IsLocation(0x10) or c:IsFaceup()) and c:IsSetCard(0xc97)
	and not c:IsCode(m)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x10+0x20,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10+0x20)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tfil0),tp,0x10+0x20,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

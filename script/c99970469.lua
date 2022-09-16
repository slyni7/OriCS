--[Aranea]
local m=99970469
local cm=_G["c"..m]
function cm.initial_effect(c)

	--공수 감소 + 장착
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	
	--세트
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
end

--공수 감소 + 장착
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe14) and c:IsType(TYPE_TUNER)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.filter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsFaceup()
end
function cm.eqfil(c)
	return c:IsSetCard(0xe14) and c:IsFaceup()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local preA=tc:GetAttack()
		local preD=tc:GetDefense()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		if (preA~=0 and tc:IsAttack(0)) or (preD~=0 and tc:IsDefense(0)) then
			local g=Duel.GetMatchingGroup(cm.eqfil,tp,LOCATION_MZONE,0,nil)
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0
				and tc:CheckUniqueOnField(tp) and not tc:IsForbidden()
				and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				local sg=g:Select(tp,1,1,nil)
				if Duel.Equip(tp,tc,sg:GetFirst())~=0 then
					local e3=Effect.CreateEffect(sg:GetFirst())
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_EQUIP_LIMIT)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetValue(cm.eqlimit)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
				end
			end
		end
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end

--세트
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
end

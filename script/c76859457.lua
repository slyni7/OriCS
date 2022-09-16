--인스톨 그리핀
local m=76859457
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con1)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.tar2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(cm.tar4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_PZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetRange(LOCATION_PZONE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,m+1)
	e6:SetCondition(cm.con6)
	e6:SetCost(cm.cost6)
	e6:SetTarget(cm.tar6)
	e6:SetOperation(cm.op6)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.afil1)
end
function cm.afil1(c)
	return c:IsSetCard(0x2c1)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()&(PHASE_DRAW+PHASE_END)>0
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)<1
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.tar2)
	Duel.RegisterEffect(e1,tp)
end
function cm.tfil1(c)
	return c:IsSetCard(0x2c1) and c:IsSSetable() and not c:IsType(TYPE_FIELD)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if chk==0 then
		return ((ft1>0 and ft2>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or (ft2>1 and b1))
			and Duel.IsExistingMatchingCard(cm.tfil1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>1
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if c:IsRelateToEffect(e) and (b1 or b2) then
		if b1 and (not b2 or Duel.SelectOption(tp,1160,1152)==0) then
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then
			return
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.tfil1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if #g>0 then
			local tc=g:GetFirst()
			Duel.SSet(tp,tc)
			if tc:IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			elseif tc:IsType(TYPE_TRAP) then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
	end
end
function cm.tar2(e,c)
	return not c:IsSetCard(0x2c1)
end
function cm.val3(e,te)
	local tc=te:GetOwner()
	if te:IsActiveType(TYPE_MONSTER) and tc:IsAttribute(ATTRIBUTE_LIGHT) then
		if tc:IsType(TYPE_LINK) then
			return tc:GetLink()%4~=0
		elseif tc:IsType(TYPE_XYZ) then
			return tc:GetRank()%4~=0
		else
			return tc:GetLevel()%4~=0
		end
	else
		return false
	end
end
function cm.tar4(e,c)
	if c:IsAttribute(ATTRIBUTE_LIGHT) then
		if c:IsType(TYPE_LINK) then
			return c:GetLink()%4~=0
		elseif c:IsType(TYPE_XYZ) then
			return c:GetRank()%4~=0
		else
			return c:GetLevel()%4~=0
		end
	else
		return false
	end
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_PZONE,0,1,c) then
		return
	end
	if re:IsActiveType(TYPE_MONSTER) and rp~=tp then
		local rc=re:GetHandler()
		local val=math.ceil(rc:GetAttack()/2)
		if val>0 then
			Duel.Hint(HINT_CARD,0,m)
			local rec=Duel.Recover(tp,val,REASON_EFFECT)
			if rec>0 then
				c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1,rec)
			end
		end
	end
end
function cm.con6(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp~=tp
end
function cm.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1000000)
	return true
end
function cm.tfil6(c,e,tp,def)
	return c:IsSetCard(0x2c1) and c:IsDefenseBelow(def) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local def=0
	local labels={c:GetFlagEffectLabel(m)}
	for i=1,#labels do
		def=def+labels[i]
	end
	if chk==0 then
		if e:GetLabel()~=1000000 then
			return false
		end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.tfil6,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,def)
			and c:IsAbleToRemoveAsCost() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	e:SetLabel(def)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local def=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tfil6,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,def)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
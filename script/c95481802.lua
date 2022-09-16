--크로노이드 파워즈
local m=95481802
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnableUnionAttribute(c,cm.ufil1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(cm.con2)
	e2:SetValue(aux.TRUE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetDescription(aux.Stringid(95481801,0))
	e3:SetTarget(cm.tar3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(95481801,1))
	e4:SetTarget(cm.tar4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
function cm.ufil1(e,c)
	return c:IsRace(RACE_PSYCHO) or e:GetHandler():GetEquipTarget()==c
end
function cm.nfil1(c)
	return c:IsFacedown() or not c:IsType(TYPE_UNION)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.nfil1,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tfil1(c,e,tp,ec)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xd54) and ec:CheckUnionTarget(c) and aux.CheckUnionEquip(ec,c)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(cm.tfil1,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
	local g=Duel.SelectTarget(tp,cm.tfil1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and aux.CheckUnionEquip(c,tc) then
		Duel.Equip(tp,c,tc)
		aux.SetUnionState(c)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.otar11)
	Duel.RegisterEffect(e1,tp)
end
function cm.otar11(e,c)
	return not c:IsSetCard(0xd54)
end
function cm.con2(e)
	local tc=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc
end
function cm.tfil3(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and ct2==0
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.tfil3(chkc)
	end
	if chk==0 then
		return c:GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingTarget(cm.tfil3,tp,LOCATION_MZONE,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cm.tfil3,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	if not tc:IsRelateToEffect(e) or not cm.tfil3(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then
		return
	end
	aux.SetUnionState(c)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
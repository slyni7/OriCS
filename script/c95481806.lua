--크로노이드 케루빔
local m=95481806
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,cm.pfil1,4,2,nil,nil,7)
	aux.EnableUnionAttribute(c,cm.ufil1)
	--not fully implemented
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetOperation(cm.op2)
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
function cm.pfil1(c)
	return c:IsSetCard(0xd54)
end
function cm.ufil1(e,c)
	return c:IsRace(RACE_PSYCHO) or e:GetHandler():GetEquipTarget()==c
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
	if c:GetEquipTarget()~=nil and loc&LOCATION_ONFIELD>0 and rp~=tp and Duel.IsChainDisablable(ev)
		and Duel.GetFlagEffect(tp,m)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) and (ph>PHASE_MAIN1 and ph<PHASE_MAIN2) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
		Duel.NegateEffect(ev)
	end
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
--크로노이드 버스트 세라핌
local m=95481814
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.pfil1,3,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.tar4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
function cm.pfil1(c)
	return c:IsFusionSetCard(0xd54)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.tfil1(c,ec)
	return c:IsSetCard(0xd54) and c:IsType(TYPE_UNION) and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec)
end
function cm.tfun1(g,tp)
	return g:GetClassCount(Card.GetLocation)==#g and g:GetClassCount(Card.GetCode)==#g and Duel.GetLocationCount(tp,LOCATION_SZONE)>=#g
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tfil1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,c)
	if chk==0 then
		return g:CheckSubGroup(cm.tfun1,1,3,tp)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	local g=Duel.GetMatchingGroup(cm.tfil1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:SelectSubGroup(tp,cm.tfun1,false,1,3,tp)
	if #sg>0 then
		local tc=sg:GetFirst()
		while tc do
			Duel.Equip(tp,tc,c)
			aux.SetUnionState(tc)
			tc=sg:GetNext()
		end
	end
end
function cm.vfil2(c)
	return c:IsFaceup() and c:IsType(TYPE_UNION)
end
function cm.val2(e,c)
	return c:GetEquipGroup():FilterCount(cm.vfil2,nil)*500
end
function cm.val3(e,c)
	return c:GetEquipGroup():FilterCount(cm.vfil2,nil)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ct=c:GetEquipGroup():FilterCount(cm.vfil2,nil)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp)
	end
	if chk==0 then
		return ct>0 and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.otar41)
	e1:SetLabel(c:GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.otar41(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
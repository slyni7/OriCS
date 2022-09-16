--[Aranea]
local m=99970466
local cm=_G["c"..m]
function cm.initial_effect(c)

	--모듈 소환
	RevLim(c)
	aux.AddModuleProcedure(c,cm.mod1,nil,1,99,nil)
	--[[local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SPSUMMON_PROC)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_EXTRA)
	e9:SetCondition(cm.spcon)
	e9:SetOperation(cm.spop)
	c:RegisterEffect(e9)]]--
	
	--수비 공격
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	--직접 공격 부여 / 튜너 제거
	local e2=MakeEff(c,"I","M")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
	--무효화
	--[[
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_SZONE)
	e3:SetTarget(cm.distg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)
	]]--
	local e3=MakeEff(c,"FC","M")
	e3:SetD(m,0)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(cm.negcon)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
	
	--수비력 증가
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetCountLimit(1)
	e5:SetOperation(cm.atkop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e6)
	
end

--모듈 소환
function cm.mod1(c)
	return c:IsModuleSetCard(0xe14) and c:IsType(TYPE_TUNER)
end
--[[
function cm.matfilter(c)
	return c:IsSetCard(0xe14) and c:IsType(TYPE_TUNER) and c:GetEquipCount()>0 and c:IsAbleToGraveAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(cm.matfilter,tp,LOCATION_MZONE,0,nil)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
]]--

--직접 공격 부여 / 튜너 제거
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function cm.dafilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe14) and c:IsType(TYPE_TUNER) and not c:IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.dafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.dafilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.dafilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_TUNER)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end

--무효화
--[[function cm.distg(e,c)
	local ec=c:GetEquipTarget()
	local def=e:GetHandler():GetDefense()
	return c:IsType(TYPE_EQUIP) and ec and (ec:GetAttack()<def or (ec:GetDefense()<def and not ec:IsType(TYPE_LINK)))
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if bit.band(tl,LOCATION_SZONE)~=0 and re:IsActiveType(TYPE_EQUIP) and rp~=tp then
		Duel.NegateEffect(ev)
	end
end
]]--
function cm.tfilter(c,tp,def)
	return c:IsFaceup() and (c:GetAttack()<def or c:GetDefense()<def) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
		and g and g:IsExists(cm.tfilter,1,nil,1-tp,e:GetHandler():GetDefense()) and Duel.IsChainDisablable(ev)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.NegateEffect(ev)
	end
end

--수비력 증가
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(ct*100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end

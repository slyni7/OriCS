--[Aranea]
local m=99970472
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	YuL.Activate(c)
	
	--공수 감소
	local e1=MakeEff(c,"Qo","S")
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--덤핑
	local e2=MakeEff(c,"Qo","G")
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)

	--소재 사용 불가
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_BE_MODULE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.sumtar)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(cm.fuslimit)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e7)
	local e8=e3:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e8)
	--local e9=e3:Clone()
	--e9:SetCode(CYAN_EFFECT_CANNOT_BE_ACCESS_MATERIAL)
	--c:RegisterEffect(e9)
	local e10=e3:Clone()
	e10:SetCode(EFFECT_CANNOT_BE_ORDER_MATERIAL)
	c:RegisterEffect(e10)

end

--공수 감소
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsSetCard,1,nil,0xe14) end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsSetCard,1,1,nil,0xe14)
	Duel.Release(g,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-700)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end

--덤핑
function cm.cfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAbleToRemoveAsCost()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe14) and c:IsAbleToGrave()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--소재 사용 불가
function cm.cfil(c)
	return c:IsSetCard(0xe14) and c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function cm.condition(e)
	return Duel.IsExistingMatchingCard(cm.cfil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.sumtar(e,c)
	return c:IsFaceup() and (c:IsAttackBelow(1000) or c:IsDefenseBelow(1000))
end
function cm.fuslimit(e,c,sumtype)
	if not c then return false end
	return not c:IsControler(e:GetHandlerPlayer()) and sumtype==SUMMON_TYPE_FUSION
end

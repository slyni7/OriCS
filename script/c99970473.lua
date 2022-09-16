--[Aranea]
local m=99970473
local cm=_G["c"..m]
function cm.initial_effect(c)

	--회복
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)

end

function cm.cfil(c)
	return c:IsSetCard(0xe14) and c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfil,tp,LOCATION_MZONE,0,1,nil)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsAbleToGrave() and (math.abs(c:GetBaseAttack()-c:GetAttack())>=700 or math.abs(c:GetBaseDefense()-c:GetDefense())>=700)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetTextAttack())
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=tc:GetTextAttack()
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) and atk~=0 then
			Duel.Recover(tp,atk,REASON_EFFECT)
		end
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end

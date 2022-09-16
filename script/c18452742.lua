--라이트닝 글로리
local m=18452742
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddDelightProcedure(c,nil,2,2,cm.pfun1)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
cm.custom_type=CUSTOMTYPE_DELIGHT
function cm.pfun1(g)
	return g:IsExists(Card.IsRace,1,nil,RACE_FAIRY)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LSTN("R"),0,1,nil)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LSTN("R"),0,nil)
	if c:IsRelateToEffect(e) and #g>0 then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(#g*300)
		c:RegisterEffect(e1)
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(Card.IsAbleToRemoveAsCost,tp,"G",0,1,nil,POS_FACEDOWN)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,Card.IsAbleToRemoveAsCost,tp,"G",0,1,1,nil,POS_FACEDOWN)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.tfil2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsOnField() and cm.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,0,"O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.STarget(tp,cm.tfil2,tp,0,"O",1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--위닝 글로리
local m=18453211
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddDelightProcedure(c,nil,3,3)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(9999)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetCost(cm.cost2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCL(1,m)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
cm.custom_type=CUSTOMTYPE_DELIGHT
function cm.cost2(e,c,tp)
	local h=e:GetHandler()
	return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,1,h,POS_FACEDOWN) or h:GetAttackAnnouncedCount()<1
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetAttackAnnouncedCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,1,1,c,POS_FACEDOWN)
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
end
function cm.tfil3(c)
	return ((c:IsSetCard(0x2e7) and c:IsType(TYPE_MONSTER) and not c:IsCode(m)) or (c:IsSetCard(0x2e8) and c:IsType(TYPE_SPELL+TYPE_TRAP)))
		and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
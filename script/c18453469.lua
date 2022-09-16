--¼±À²°ú ÀüÀ²ÀÇ ½ºÆä¼È¸®½ºÆ®
local m=18453469
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCL(1,m)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STf")
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCL(1,m+1)
	WriteEff(e3,3,"NC")
	WriteEff(e3,2,"O")
	c:RegisterEffect(e3)
end
function cm.tfil1(c)
	return c:IsSetCard("½ºÇÃ¸´") and c:IsSSetable() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"S")>0 and Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"S")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		Duel.SSet(tp,tc)
	end
end
function cm.cfil2(c)
	return c:IsSetCard("½ºÇÃ¸´") and c:IsFacedown() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil2,tp,"S",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SMCard(tp,cm.cfil2,tp,"S",0,1,1,nil)
	Duel.ChangePosition(g,POS_FACEUP)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SOI(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LSTN("HD"))
end
function cm.cfil3(c)
	return c:IsSetCard("½ºÇÃ¸´") and c:IsAbleToGraveAsCost() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil3,tp,"HO",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.cfil3,tp,"HO",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
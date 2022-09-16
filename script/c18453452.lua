--러셀의 찻주전자
local m=18453452
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","HM")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCL(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetCL(1,m)
	e2:SetCost(aux.bfgcost)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S","M")
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCondition(cm.con3)
	e3:SetValue(3000)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"S")
	e4:SetCode(EFFECT_PIERCE)
	e4:SetCondition(cm.con3)
	c:RegisterEffect(e4)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function cm.tfil1(c)
	return c:IsLevelAbove(5) and not c:IsCode(m) and c:IsSummonableCard() and c:IsAbleToGrave()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(g,REASON_EFFECT)>0 and tc:IsLoc("G") then
		local e1=MakeEff(c,"F","G")
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetTarget(aux.TRUE)
		tc:RegisterEffect(e1,true)
		local e2=MakeEff(c,"FC","G")
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetD(m,0)
		e2:SetCL(1)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,2)
		e2:SetLabel(Duel.GetTurnCount())
		e2:SetCondition(cm.ocon12)
		e2:SetOperation(cm.oop12)
		tc:RegisterEffect(e2)
	end
end
function cm.ocon12(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnCount()~=e:GetLabel() and c:IsAbleToHand()
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,c)
end
function cm.tfil2(c)
	return c:IsSummonable(true,nil) and c:IsLevelAbove(5)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"H",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"H",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function cm.con3(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_NORMAL)
end
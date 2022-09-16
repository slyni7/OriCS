--아틀란티스 소녀
local m=18453458
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetD(m,0)
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(m)
	e2:SetValue(SUMMON_TYPE_NORMAL)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","HM")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetCL(1,m)
	e3:SetLabelObject(e2)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","G")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetCL(1,m)
	e4:SetLabelObject(e2)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"S")
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"F","M")
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_REVERSE_DAMAGE)
	e6:SetTR(1,0)
	e6:SetValue(cm.val6)
	c:RegisterEffect(e6)
end
function cm.con1(e,c,minc)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return minc==0 and c:GetLevel()>4 and Duel.GetLocCount(tp,"M")>0
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable() and Duel.CheckLPCost(tp,1700)
	end
	Duel.Release(c,REASON_COST)
	Duel.PayLPCost(tp,1700)
end
function cm.tfil3(c,se,ct)
	if not c:IsSummonableCard() then
		return false
	end
	local mi,ma=c:GetTributeRequirement()
	if ct and mi~=ct and ma~=ct then
		return false
	end
	return mi>0 and c:IsSummonable(false,se)
end
function cm.tval3(se,tp,ct)
	local g=Duel.GMGroup(cm.tfil3,tp,"H",0,nil,se,ct)
	local minct=5
	local maxct=0
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local mi,ma=tc:GetTributeRequirement()
		if mi>0 and mi<minct then
			minct=mi
		end
		if ma>maxct then
			maxct=ma
		end
	end
	return minct,maxct
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local se=e:GetLabelObject()
	if chk==0 then
		local mi,ma=cm.tval3(se,tp,1)
		return mi<=1
	end
	Duel.SOI(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"H",0,1,1,nil,se,1)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,false,se)
	end
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost() and Duel.CheckLPCost(tp,2700)
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	c:CreateEffectRelation(e)
	Duel.PayLPCost(tp,2700)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local se=e:GetLabelObject()
	if chk==0 then
		local mi,ma=cm.tval3(se,tp,2)
		return mi<=2
	end
	Duel.SOI(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"H",0,1,1,nil,se,2)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,false,se)
	end
	if c:IsRelateToEffect(e) then
		local e1=MakeEff(c,"FC","R")
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCL(1)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_EVENT+RESETS_STANDARD,2)
			e1:SetLabel(Duel.GetTurnCount())
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_EVENT+RESETS_STANDARD)
		end
		e1:SetCondition(cm.ocon41)
		e1:SetOperation(cm.oop41)
		c:RegisterEffect(e1)
	end
end
function cm.ocon41(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAbleToHand() and Duel.GetTurnCount()~=e:GetLabel()
end
function cm.oop41(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,c)
end
function cm.val6(e,re,r,rp,rc)
	local c=e:GetHandler()
	return bit.band(r,REASON_BATTLE)>0 and c:IsRelateToBattle()
end
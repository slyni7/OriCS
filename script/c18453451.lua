--오르트구름
local m=18453451
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","HM")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1,m)
	WriteEff(e2,2,"C")
	WriteEff(e2,1,"TO")
	c:RegisterEffect(e2)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable() and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
	end
	Duel.Release(c,REASON_COST)
	c:CreateEffectRelation(e)
	local e1=MakeEff(c,"F")
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local loc=c:GetLocation()
		local e1=MakeEff(c,"FC",loc)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetD(m,0)
		e1:SetCL(1)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_EVENT+RESETS_STANDARD,2)
			e1:SetLabel(Duel.GetTurnCount())
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_EVENT+RESETS_STANDARD)
		end
		e1:SetCondition(cm.ocon11)
		e1:SetOperation(cm.oop11)
		c:RegisterEffect(e1)
	end
end
function cm.ocon11(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocCount(tp,"M")>0 and Duel.GetTurnCount()~=e:GetLabel()
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LSTN("M"),POS_FACEUP_DEFENSE,true)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost() and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	c:CreateEffectRelation(e)
	local e1=MakeEff(c,"F")
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
end
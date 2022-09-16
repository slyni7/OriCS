--¹Ù´Ò¶ó¼ÖÆ® Ã¿
local m=18453016
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"C")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","S")
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTR(1,0)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTf","M")
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetD(m,0)
	e3:SetCL(1)
	WriteEff(e3,3,"O")
	local e4=MakeEff(c,"FG","S")
	e4:SetTR("M","M")
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.afil1)
end
function cm.afil1(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)<1
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	e1:SetTarget(cm.ctar11)
	Duel.RegisterEffect(e1,tp)
end
function cm.ctar11(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLoc("E")
end
function cm.val2(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLoc("M")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GMGroup(Card.IsFaceup,tp,0,"M",nil)
	local tc=g:GetFirst()
	while tc do
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,2)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
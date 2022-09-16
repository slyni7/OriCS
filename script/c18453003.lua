--바닐라솔트 솔
local m=18453003
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","G")
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.afil1)
end
function cm.afil1(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA
end
function cm.tfil1(c)
	return c:IsSetCard("바닐라솔트") and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)<1
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	e1:SetTarget(cm.ctar21)
	Duel.RegisterEffect(e1,tp)
end
function cm.ctar21(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLoc("E")
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,1000,0,1,RACE_FAIRY,ATTRIBUTE_EARTH)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,1000,0,1,RACE_FAIRY,ATTRIBUTE_EARTH) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e2=MakeEff(c,"F","M")
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetAbsoluteRange(tp,1,0)
		e2:SetValue(cm.oval22)
		c:RegisterEffect(e2)
		local e3=MakeEff(c,"S")
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e3:SetValue(LSTN("D"))
		c:RegisterEffect(e3)
		Duel.SpecialSummonComplete()
	end
end
function cm.oval22(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLoc("M")
end
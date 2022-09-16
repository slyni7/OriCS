--바닐라솔트 폴
local m=18453005
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
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
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>1
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m+3,0,0x4011,1000,0,1,RACE_FAIRY,ATTRIBUTE_EARTH)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SOI(0,CATEGORY_TOKEN,nil,2,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<2 then
		return
	end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,m+3,0,0x4011,1000,0,1,RACE_FAIRY,ATTRIBUTE_EARTH) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,m+3)
			Duel.SpecialSummonStep(token,0,tp,tp,true,false,POS_FACEUP)
			local e2=MakeEff(c,"F","M")
			e2:SetCode(EFFECT_CANNOT_ACTIVATE)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetAbsoluteRange(tp,1,0)
			e2:SetValue(cm.oval12)
			token:RegisterEffect(e2)
			local e3=MakeEff(c,"SC")
			e3:SetCode(EVENT_RELEASE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetLabel(tp)
			e3:SetOperation(cm.oop13)
			token:RegisterEffect(e3)
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.oval12(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLoc("M")
end
function cm.oofil13(c)
	return c:IsSetCard("바닐라솔트") and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.oop13(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	Duel.Hint(HINT_CARD,0,m+3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(p,cm.oofil13,p,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,g)
	end
end
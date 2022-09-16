--¹Ù´Ò¶ó¼ÖÆ® ´Ò
local m=18453012
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","F")
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTR(1,0)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","F")
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCL(1)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.afil1)
end
function cm.afil1(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA
end
function cm.val2(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLoc("M")
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)<1
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	e1:SetTarget(cm.ctar31)
	Duel.RegisterEffect(e1,tp)
end
function cm.ctar31(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLoc("E")
end
function cm.tfil3(c)
	return c:IsSetCard("¹Ù´Ò¶ó¼ÖÆ®") and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
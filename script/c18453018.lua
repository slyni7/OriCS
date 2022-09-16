--바닐라솔트 올
local m=18453018
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.afil1)
end
function cm.afil1(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA
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
function cm.tfil2(c)
	return c:IsSetCard("바닐라솔트") and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and cm.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil2,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,cm.tfil2,tp,"G",0,1,2,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,#g,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
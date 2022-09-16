--¹Ù´Ò¶ó¼ÖÆ® Ä®
local m=18453022
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.afil1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.afil2)
end
function cm.afil1(re,tp,cid)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
	return loc&LSTN("M")<1
end
function cm.afil2(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainNegatable(ev) and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)<1
			and Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,"¹Ù´Ò¶ó¼ÖÆ®")
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	e1:SetValue(cm.cval11)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,"¹Ù´Ò¶ó¼ÖÆ®")
	Duel.Release(g,REASON_COST)
end
function cm.cval11(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLoc("M")
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)<1 and c:IsAbleToDeckAsCost()
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	e1:SetTarget(cm.ctar21)
	Duel.RegisterEffect(e1,tp)
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.ctar21(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLoc("E")
end
function cm.tfil2(c)
	return c:IsSetCard("¹Ù´Ò¶ó¼ÖÆ®") and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
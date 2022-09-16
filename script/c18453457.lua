--이름에게
local m=18453457
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","G")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCondition(aux.exccon)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function cm.nfil1(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function cm.con1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.CheckReleaseGroupCost(tp,cm.nfil1,1,true,nil,nil)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	if c:IsStatus(STATUS_ACT_FROM_HAND) and Duel.GetTurnPlayer()~=tp then
		local g=Duel.SelectReleaseGroupCost(tp,cm.nfil1,1,1,true,nil,nil)
		Duel.Release(g,REASON_COST)
	end
end
function cm.tfil2(c)
	return (c:IsCode(18453448) or (c:IsRace(RACE_CYBERSE) and c:IsAttribute(ATTRIBUTE_WATER))) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.ofil2(c)
	return c:IsCode(18453448) and c:IsSummonable(true,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetFlagEffect(tp,m)==0 and Duel.IEMCard(cm.ofil2,tp,"H",0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SMCard(tp,cm.ofil2,tp,"H",0,1,1,nil)
			local tc=sg:GetFirst()
			if tc then
				Duel.Summon(tp,tc,true,nil)
			end
			Duel.RegisterFlagEffect(tp,m,0,0,0)
		end
	end
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	c:CreateEffectRelation(e)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,TYPE_MONSTER)
	Duel.SetTargetParam(ac)
	Duel.SOI(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local e1=MakeEff(c,"FC","R")
		e1:SetCode(EVENT_REMOVE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabel(ac)
		e1:SetCondition(cm.ocon31)
		e1:SetOperation(cm.oop31)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.onfil31(c,tp,ac)
	return c:IsCode(ac) and c:IsControler(tp) and c:IsAbleToHand()
end
function cm.ocon31(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAbleToHand() and eg:IsExists(cm.onfil31,1,nil,tp,e:GetLabel())
end
function cm.oop31(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=eg:FilterSelect(tp,cm.onfil31,1,1,nil,tp,e:GetLabel())
	g:AddCard(c)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
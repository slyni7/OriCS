--Èå¸´ÇØÁ®°¡´Â °æ°è¼±
local m=18453471
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetCL(1,m+EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","F")
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTR("M",0)
	e2:SetValue(400)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STf")
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e4,4,"NO")
	c:RegisterEffect(e4)
end
function cm.ofil1(c)
	return c:IsCode(18453469) and c:IsAbleToHand()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.ofil1,tp,"D",0,0,1,nil)
			if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.nfil2(c)
	return c:IsSetCard("½ºÇÃ¸´") and c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function cm.con2(e)
	local tp=e:GetHandler()
	return Duel.IEMCard(cm.nfil2,tp,"O",0,1,nil)
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LSTN("HD"))
end
function cm.ofil4(c)
	return c:IsSetCard("½ºÇÃ¸´") and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.ofil4,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFCT)
		Duel.ConfirmCards(1-tp,g)
	end
end
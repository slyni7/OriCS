--줄라이 메리
local m=18453174
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"X")
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function cm.val1(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x2e5) then
		if c:IsType(TYPE_XYZ) then
			local clv=c:GetRank()
			return clv*65536+lv
		else
			local clv=c:GetLevel()
			return clv*65536+lv
		end
	end
	return lv
end
function cm.tfil2(c)
	return c:IsSetCard(0x12e5) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
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
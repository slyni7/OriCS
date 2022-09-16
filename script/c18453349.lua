--smilegirl(미소미소녀) Y
local m=18453349
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"FTo","G")
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.tfil1(c)
	return c:IsCode(18453348) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand() and Duel.IEMCard(cm.tfil1,tp,"DG",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,c,2,tp,"DG")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsAbleToHand() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil1,tp,"DG",0,1,1,nil)
		if #g>0 then
			g:AddCard(c)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
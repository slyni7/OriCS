--인투 디 언논 메모리
local m=18452750
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","S")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetD(m,0)
	e2:SetCL(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","S")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetD(m,1)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("R") and chkc:IsFacedown()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFacedown,tp,LSTN("R"),0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LSTN("R"),0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,0,0,0)
end
function cm.ofil2(c)
	return c:IsFaceup() and c:IsCustomType(CUSTOMTYPE_DELIGHT)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if tc:IsAbleToHand() and Duel.IEMCard(cm.ofil2,tp,"M",0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
		end
	end
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost(POS_FACEDOWN)
	end
	Duel.Remove(c,POS_FACEDOWN,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(Card.IsFacedown,tp,"R",0,nil)
	if chk==0 then
		return #g>0 and Duel.IsPlayerCanDiscardDeck(tp,#g)
	end
	Duel.SOI(0,CATEGORY_DECKDES,nil,0,tp,#g)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(Card.IsFacedown,tp,"R",0,nil)
	Duel.DiscardDeck(tp,#g,REASON_EFFECT)
end
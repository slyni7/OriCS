--[ [ Matryoshka ] ]
local m=99970087
local cm=_G["c"..m]
function cm.initial_effect(c)

	--마트료시카
	YuL.MatryoshkaProcedure(c,nil,nil,0)
	YuL.MatryoshkaOpen(c,nil)
	
	--샐비지
	local e1=MakeEff(c,"STo")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCL(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

	--직접 공격 부여
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	
end

--샐비지
function cm.tar1fil(c)
	return c:IsSetCard(0xd37) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.tar1fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar1fil,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.tar1fil,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

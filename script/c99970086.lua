--[ [ Matryoshka ] ]
local m=99970086
local cm=_G["c"..m]
function cm.initial_effect(c)

	--마트료시카
	YuL.MatryoshkaProcedure(c,nil,nil,0)
	YuL.MatryoshkaOpen(c,nil)
	
	--바운스
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(YuL.turn(1))
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	
end

--바운스
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--내성 부여
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

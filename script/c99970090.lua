--[ [ Matryoshka ] ]
local m=99970090
local cm=_G["c"..m]
function cm.initial_effect(c)

	--마트료시카
	YuL.MatryoshkaProcedure(c,nil,nil,0)
	YuL.MatryoshkaOpen(c,nil)
	
	--소재 흡수
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(m,0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1)
	e1:SetCost(spinel.rmovcost(2))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

	--제거
	local e2=MakeEff(c,"STo")
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCL(1,m)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
end

--소재 흡수
function cm.tar1fil(c)
	return not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.tar1fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar1fil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.tar1fil,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end

--제거
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_OVERLAY)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.GetOverlayCount(e:GetHandlerPlayer(),1,1)>1
		and Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=Duel.GetOverlayCount(e:GetHandlerPlayer(),1,1)-1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

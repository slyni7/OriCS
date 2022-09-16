--[ Lava Golem ]
local m=99970720
local cm=_G["c"..m]
function cm.initial_effect(c)

	--패 발동
	YuL.Activate(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	
	--파괴 / 바운스  + 데미지
	local e2=MakeEff(c,"Qo","S")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCL(1)
	e2:SetHintTiming(0,0x1e0)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)

	--회수 + 드로우
	local e1=MakeEff(c,"STo")
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(spinel.delay+EFFECT_FLAG_CARD_TARGET)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

end

--패 발동
function cm.hdfilter(c)
	return c:IsFaceup() and c:IsLavaGolem()
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.hdfilter,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,1,nil)
end

--파괴 / 바운스  + 데미지
function cm.filter(c)
	return c:IsFaceup() and c:IsLavaGolemCard()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	if g1:Filter(Card.IsLavaGolemCard,nil):GetCount()==2 then
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	else e:SetLabel(0) end	
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		if g:Filter(Card.IsAbleToHand,nil):GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Destroy(g,REASON_EFFECT)
		else
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
		if e:GetLabel()==1 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end

--회수 + 드로우
function cm.tdfilter(c)
	return c:IsLavaGolemCard() and c:IsAbleToDeck()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,4,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,4,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

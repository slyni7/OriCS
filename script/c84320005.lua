--유키-쌓여가는 기억
function c84320005.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84320005,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(c84320005.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c84320005.reptg)
	e2:SetOperation(c84320005.repop)
	c:RegisterEffect(e2)
	--gravetohand
	local e3=Effect.CreateEffect(c)
	 e3:SetDescription(aux.Stringid(84320105,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetRange(LOCATION_MZONE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetCost(c84320005.spcost)
	e3:SetTarget(c84320005.target)
	e3:SetOperation(c84320005.activate)
	c:RegisterEffect(e3)
end
function c84320005.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1234,1)
		tc=g:GetNext()
	end
end
function c84320005.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1234,1,REASON_EFFECT) end
	return Duel.SelectYesNo(tp,aux.Stringid(84320005,2))
end
function c84320005.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x1234,1,REASON_EFFECT)
end
function c84320005.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1234,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1234,4,REASON_COST)
end
function c84320005.filter(c)
	return c:IsSetCard(0x7a0) or c:IsCode(59438930) or c:IsCode(55623480) and c:IsAbleToDeck()
end
function c84320005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c84320005.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		 and Duel.IsCanRemoveCounter(tp,1,1,0x1234,4,REASON_COST)
		and Duel.IsExistingTarget(c84320005.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,4,nil) end
	Duel.RemoveCounter(tp,1,1,0x1234,4,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c84320005.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,4,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c84320005.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=4 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.ShuffleDeck(tp)
	end
	Duel.BreakEffect()
	Duel.Draw(tp,2,REASON_EFFECT)
end



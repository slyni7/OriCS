--stop it!
function c84320044.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c84320044.condition)
	e1:SetTarget(c84320044.target)
	e1:SetCountLimit(1,84320044,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c84320044.activate)
	c:RegisterEffect(e1)
	--act qp in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_HAND)
	c:RegisterEffect(e2)
end
function c84320044.costfilter(c)
	return c:IsLocation(LOCATION_MZONE)
end
function c84320044.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	return ct>0 and ct>=6
end
function c84320044.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c84320044.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	Duel.BreakEffect()
	Duel.Draw(p,2,REASON_EFFECT)
end


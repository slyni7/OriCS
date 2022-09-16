--サイコパス
function c95480220.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480220+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c95480220.cost)
	e1:SetTarget(c95480220.target)
	e1:SetOperation(c95480220.activate)
	c:RegisterEffect(e1)
end
c95480220.Mekakuci_list=true
function c95480220.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480220.rfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c95480220.rfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c95480220.rfilter(c)
	return c:IsSetCard(0xd4c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c95480220.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c95480220.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end


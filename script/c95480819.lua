--클라디스 글로리
function c95480819.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480819+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95480819.target)
	e1:SetOperation(c95480819.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44640691,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c95480819.setcost)
	e2:SetTarget(c95480819.settg)
	e2:SetOperation(c95480819.setop)
	c:RegisterEffect(e2)
end
function c95480819.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd52) and c:IsDiscardable()
end
function c95480819.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480819.tgfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c95480819.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c95480819.tgfilter,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end

function c95480819.cfilter(c)
	return c:IsSetCard(0xd52) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c95480819.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c95480819.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c95480819.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c95480819.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c95480819.setop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

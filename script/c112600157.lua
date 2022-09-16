--아다만트의 사서 크리스
local m=112600157
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Pendulum Summon
	c:EnableCounterPermit(0xe8a,LOCATION_PZONE+LOCATION_MZONE)
	aux.EnablePendulumAttribute(c)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.indoval)
	e2:SetCondition(cm.incon)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCost(cm.drcost)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
	--indes2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(cm.target)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe8a))
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--to hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetCountLimit(1,m)
	e6:SetCost(cm.thcost)
	e6:SetTarget(cm.thtg)
	e6:SetOperation(cm.thop)
	c:RegisterEffect(e6)
end

--add counter
function cm.ctfilter(c,tp)
	return c:IsControler(tp) and c:IsRace(RACE_PLANT)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.ctfilter,1,nil,tp) then
		e:GetHandler():AddCounter(0xe8a,1)
	end
end

--indes
function cm.incon(e)
	return e:GetHandler():GetCounter(0xe8a)>0
end

--draw
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xe8a,7,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xe8a,7,REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--indes2
function cm.target(e,c)
	return c:IsSetCard(0xe8a)
end

--to hand
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
--시독의 늪
function c95480717.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk&def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c95480717.valcon)
	e2:SetValue(-500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(25857246,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,95480717)
	e5:SetCost(c95480717.cost)
	e5:SetTarget(c95480717.target)
	e5:SetOperation(c95480717.operation)
	c:RegisterEffect(e5)
end
function c95480717.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd4a)
end
function c95480717.valcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c95480717.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c95480717.cfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end
function c95480717.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c95480717.cfilter,1,nil) end
	local sg=Duel.SelectReleaseGroupEx(tp,c95480717.cfilter,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c95480717.thfilter(c)
	return c:IsSetCard(0xd4a) and c:IsAbleToHand()
end
function c95480717.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480717.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95480717.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95480717.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

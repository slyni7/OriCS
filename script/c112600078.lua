--GLS(글라시스)-ETAILE
function c112600078.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c112600078.xyzcon)
	e0:SetOperation(c112600078.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112600078,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c112600078.thtg1)
	e1:SetOperation(c112600078.thop1)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112600078,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c112600078.discon)
	e2:SetCost(c112600078.discost)
	e2:SetTarget(c112600078.distg)
	e2:SetOperation(c112600078.disop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112600078,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c112600078.rmcost)
	e3:SetTarget(c112600078.rmtg)
	e3:SetOperation(c112600078.rmop)
	c:RegisterEffect(e3)
end
function c112600078.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xe8e) and c:IsCanBeXyzMaterial(xyzc)
end
function c112600078.xyzfilter1(c,g,ct)
	return g:IsExists(c112600078.xyzfilter2,ct,c,c:GetRank())
end
function c112600078.xyzfilter2(c,rk)
	return c:GetRank()==rk
end
function c112600078.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=math.max(1,-ft)
	local mg=Duel.GetMatchingGroup(c112600078.mfilter,tp,LOCATION_MZONE,0,nil,c)
	return mg:IsExists(c112600078.xyzfilter1,1,nil,mg,ct)
end
function c112600078.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=math.max(1,-ft)
	local mg=Duel.GetMatchingGroup(c112600078.mfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=mg:FilterSelect(tp,c112600078.xyzfilter1,1,1,nil,mg,ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=mg:FilterSelect(tp,c112600078.xyzfilter2,ct,63,g1:GetFirst(),g1:GetFirst():GetRank())
	g1:Merge(g2)
	local sg=Group.CreateGroup()
	local tc=g1:GetFirst()
	while tc do
		sg:Merge(tc:GetOverlayGroup())
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end
function c112600078.thfilter1(c)
	return c:IsSetCard(0xe8e) and c:IsAbleToHand()
end
function c112600078.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112600078.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112600078.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c112600078.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c112600078.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c112600078.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c112600078.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c112600078.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c112600078.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c112600078.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c112600078.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
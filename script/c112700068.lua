--비욘드 레인보우
local m=112700068
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddBeyondProcedure(c,nil,">","L",aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT))
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.tdcon)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.negcon)
	e4:SetCost(cm.negcost)
	e4:SetTarget(cm.negtg)
	e4:SetOperation(cm.negop)
	c:RegisterEffect(e4)
	--draw
	local e20=Effect.CreateEffect(c)
	e20:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e20:SetDescription(aux.Stringid(m,2))
	e20:SetType(EFFECT_TYPE_IGNITION)
	e20:SetRange(LOCATION_GRAVE)
	e20:SetCountLimit(1,m+2)
	e20:SetCost(aux.bfgcost)
	e20:SetTarget(cm.tdtg)
	e20:SetOperation(cm.tdop)
	c:RegisterEffect(e20)
end

cm.custom_type=CUSTOMTYPE_BEYOND

--to deck
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_BEYOND)
end
function cm.tdfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cm.cfilter(c,p)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(p)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,2,nil)
	if Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)~=0 then
	end
end

--negate
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function cm.cfilter(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end

--draw
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
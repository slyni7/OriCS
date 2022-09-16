--구세의 단죄계시
function c95481117.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95481117,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c95481117.cost)
	e1:SetTarget(c95481117.target)
	e1:SetOperation(c95481117.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c95481117.handcon)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(52068432,0))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c95481117.negcon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c95481117.negtg)
	e4:SetOperation(c95481117.negop)
	c:RegisterEffect(e4)
end

function c95481117.costfilter(c)
	return c:IsSetCard(0xd5c)
end
function c95481117.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c95481117.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c95481117.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c95481117.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mc=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if chk==0 then return mc>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
end
function c95481117.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end


function c95481117.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0xd5c)
end
function c95481117.handcon(e)
	return not Duel.IsExistingMatchingCard(c95481117.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function c95481117.tfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xd5c) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c95481117.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c95481117.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c95481117.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c95481117.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c95481117.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
end
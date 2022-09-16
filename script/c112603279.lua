--Good Bye, Merry-Go-Round.
local m=112603279
local cm=_G["c"..m]
function cm.initial_effect(c)
	--beyond summon
	c:EnableReviveLimit()
	aux.AddBeyondProcedure(c,nil,">","L",cm.matfilter,cm.matfilter)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.discon)
	e3:SetCost(cm.discost)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
	--destroy
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(m,1))
	e21:SetCategory(CATEGORY_DESTROY)
	e21:SetType(EFFECT_TYPE_QUICK_O)
	e21:SetCode(EVENT_FREE_CHAIN)
	e21:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCountLimit(1,m)
	e21:SetTarget(cm.destg)
	e21:SetOperation(cm.desop)
	c:RegisterEffect(e21)
end

cm.custom_type=CUSTOMTYPE_BEYOND

--beyond summon
function cm.matfilter(c)
	return c:IsCustomType(CUSTOMTYPE_BEYOND) and c:IsSetCard(0xe9f)
end

--negate
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

--destroy
function cm.rmfilter(c)
	return c:IsSetCard(0xe9f) and c:IsAbleToRemoveAsCost()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.rmfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_GRAVE)
	local h=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,h,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
end
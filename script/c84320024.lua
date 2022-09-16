--샤를로트-이로울
function c84320024.initial_effect(c)
    c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84320024,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c84320024.hspcon)
	e1:SetOperation(c84320024.hspop)
	c:RegisterEffect(e1)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(84320024,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(c84320024.tdcost)
	e3:SetTarget(c84320024.tdtg)
	e3:SetOperation(c84320024.tdop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(84320024,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c84320024.discon)
	e4:SetCost(c84320024.discost)
	e4:SetTarget(c84320024.distg)
	e4:SetOperation(c84320024.disop)
	c:RegisterEffect(e4)
    --to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(84320024,3))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,84320124)
	e5:SetTarget(c84320024.rettg)
	e5:SetOperation(c84320024.retop)
	c:RegisterEffect(e5)
end


function c84320024.spfilter(c)
   return c:IsSetCard(0x7a1) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
end
function c84320024.hspcon(e,c)
   if c==nil then return true end
   local tp=c:GetControler()
   local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
   if ft<=-1 then return false end
   if ft<=0 then
      return Duel.IsExistingMatchingCard(c84320024.spfilter,tp,LOCATION_MZONE,0,1,c)
   else return Duel.IsExistingMatchingCard(c84320024.spfilter,tp,0x16,0,1,c) end
end
function c84320024.hspop(e,tp,eg,ep,ev,re,r,rp,c)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
      local g=Duel.SelectMatchingCard(tp,c84320024.spfilter,tp,LOCATION_MZONE,0,1,1,c)
      Duel.Remove(g,POS_FACEUP,REASON_COST)
   else
      local g=Duel.SelectMatchingCard(tp,c84320024.spfilter,tp,0x16,0,1,1,c)
      Duel.Remove(g,POS_FACEUP,REASON_COST)
   end
end



function c84320024.cfilter(c)
	return c:IsSetCard(0x7a1) and c:IsAbleToRemoveAsCost()
end
function c84320024.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84320024.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c84320024.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c84320024.tdfilter(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsAbleToDeck()
end
function c84320024.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c84320024.tdfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c84320024.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c84320024.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c84320024.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end




function c84320024.discon(e,tp,eg,ep,ev,re,r,rp)
   return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and ep~=tp
end
function c84320024.costfilter(c)
	return c:IsSetCard(0x7a1) and c:IsAbleToGraveAsCost()
end
function c84320024.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84320024.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c84320024.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c84320024.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c84320024.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end





function c84320024.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c84320024.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end

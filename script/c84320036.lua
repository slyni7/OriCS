--key hole tipping
function c84320036.initial_effect(c)
   local e1=Effect.CreateEffect(c)
   e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
   e1:SetType(EFFECT_TYPE_ACTIVATE)
   e1:SetCode(EVENT_CHAINING)
   e1:SetCondition(c84320036.condition)
   e1:SetCost(c84320036.cost)
   e1:SetTarget(c84320036.target)
   e1:SetOperation(c84320036.operation)
   c:RegisterEffect(e1)
end
function c84320036.condition(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.IsChainDisablable(ev) then return false end
   local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_DISABLE)
   local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_NEGATE)
   return (ex1 and g1:IsExists(Card.IsType,1,nil,TYPE_MONSTER))
      or (ex2 and g2:IsExists(Card.IsType,1,nil,TYPE_MONSTER))
      or eg:IsExists(Card.IsCode,1,nil,83326048,1639384,82732705,7127502,53778229,60434189,9852718,24348804,53341729,99735427,74371660,8719957,22888900,26822796,30845999,63227401,65384188,33950246,26257572,84428023,32754886,12735388,48716527,28643791,96381979,70329348,71417170,86848580,48333324)
      or re:GetDescription()==aux.Stringid(2407234,0)
	  or re:GetDescription()==aux.Stringid(81146288,0)
      or (eg:IsExists(Card.IsCode,1,nil,19578592) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c84320036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.CheckLPCost(tp,1500) end
   Duel.PayLPCost(tp,1500)
end
function c84320036.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
   Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
   if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
      Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
   end
end
function c84320036.operation(e,tp,eg,ep,ev,re,r,rp)
   if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
      Duel.Destroy(eg,REASON_EFFECT)
   end
end
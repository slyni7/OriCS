--샤를로트-라미엘
function c84320023.initial_effect(c)
   --search
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(84320023,0))
   e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
   e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
   e1:SetCode(EVENT_SUMMON_SUCCESS)
   e1:SetProperty(EFFECT_FLAG_DELAY)
   e1:SetCountLimit(1,84320023)
   e1:SetCost(c84320023.cost)
   e1:SetTarget(c84320023.tg)
   e1:SetOperation(c84320023.op)
   c:RegisterEffect(e1)
   local e2=e1:Clone()
   e2:SetCode(EVENT_SPSUMMON_SUCCESS)
   c:RegisterEffect(e2)
   --Activate(effect)
   local e3=Effect.CreateEffect(c)
   e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
   e3:SetType(EFFECT_TYPE_ACTIVATE)
   e3:SetRange(LOCATION_MZONE)
   e3:SetCode(EVENT_CHAINING)
   e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
   e3:SetCondition(c84320023.condition2)
   e3:SetCost(c84320023.cost2)
   e3:SetTarget(c84320023.target2)
   e3:SetOperation(c84320023.activate2)
   c:RegisterEffect(e3)
   --to hand
   local e4=Effect.CreateEffect(c)
   e4:SetDescription(aux.Stringid(84320023,1))
   e4:SetCategory(CATEGORY_TOHAND)
   e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
   e4:SetCode(EVENT_TO_GRAVE)
   e4:SetProperty(EFFECT_FLAG_DELAY)
   e4:SetCountLimit(1,84320123)
   e4:SetTarget(c84320023.rettg)
   e4:SetOperation(c84320023.retop)
   c:RegisterEffect(e4)
end

function c84320023.drcfilter(c)
   return c:IsSetCard(0x7a1) and c:IsDiscardable()
end
function c84320023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c84320023.drcfilter,tp,LOCATION_HAND,0,1,nil) end
   Duel.DiscardHand(tp,c84320023.drcfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c84320023.tg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then
      if not Duel.IsEnvironment(84320029) then
         return Duel.IsPlayerCanDraw(tp,1) end
      return Duel.IsPlayerCanDraw(tp,2)
   end
   Duel.SetTargetPlayer(tp)
   Duel.SetTargetParam(1)
   Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,nil)
end
function c84320023.op(e,tp,eg,ep,ev,re,r,rp)
   local p,g=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
   if Duel.IsEnvironment(84320029) then g=2  end
      Duel.Draw(p,g,REASON_EFFECT)
end







function c84320023.condition2(e,tp,eg,ep,ev,re,r,rp)
   return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c84320023.drcofilter(c)
   return c:IsLocation(LOCATION_ONFIELD) and c:IsDestructable()
end
function c84320023.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c84320023.drcofilter,tp,LOCATION_ONFIELD,0,1,nil) end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
   local g=Duel.SelectMatchingCard(tp,c84320023.drcofilter,tp,LOCATION_ONFIELD,0,1,1,nil)
   Duel.Destroy(g,REASON_COST)
end
function c84320023.target2(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
   Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
   if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
      Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
   end
end
function c84320023.activate2(e,tp,eg,ep,ev,re,r,rp)
   Duel.NegateActivation(ev)
   if re:GetHandler():IsRelateToEffect(re) then
      Duel.Destroy(eg,REASON_EFFECT)
   end
end



function c84320023.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c84320023.retop(e,tp,eg,ep,ev,re,r,rp)
   if e:GetHandler():IsRelateToEffect(e) then
      Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
   end
end





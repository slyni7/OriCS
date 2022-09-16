--유키의 은총
function c84320046.initial_effect(c)
   --Activate
   local e1=Effect.CreateEffect(c)
   e1:SetCategory(CATEGORY_DRAW)
   e1:SetType(EFFECT_TYPE_ACTIVATE)
   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
   e1:SetCode(EVENT_FREE_CHAIN)
   e1:SetCost(c84320046.cost)
   e1:SetTarget(c84320046.target)
   e1:SetOperation(c84320046.activate)
   c:RegisterEffect(e1)
end
function c84320046.filter(c)
   return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7a0) or c:IsCode(59438930) or c:IsCode(55623480) and c:IsAbleToRemoveAsCost()
end
function c84320046.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c84320046.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
   local g=Duel.SelectMatchingCard(tp,c84320046.filter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
   Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c84320046.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
   Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c84320046.activate(e,tp,eg,ep,ev,re,r,rp)
   Duel.Draw(tp,2,REASON_EFFECT)
end
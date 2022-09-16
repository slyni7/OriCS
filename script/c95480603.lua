--이레귤러: 디멘션 크레비스
function c95480603.initial_effect(c)
   --remove
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(62950604,0))
   e1:SetCategory(CATEGORY_REMOVE)
   e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
   e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
   e1:SetCode(EVENT_SUMMON_SUCCESS)
   e1:SetCountLimit(1,95480603)
   e1:SetTarget(c95480603.rmtg)
   e1:SetOperation(c95480603.rmop)
   c:RegisterEffect(e1)
   local e2=e1:Clone()
   e2:SetCode(EVENT_SPSUMMON_SUCCESS)
   c:RegisterEffect(e2)
   --special summon
   local e3=Effect.CreateEffect(c)
   e3:SetDescription(aux.Stringid(95480603,1))
   e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
   e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
   e3:SetCode(EVENT_TO_GRAVE)
   e3:SetCondition(c95480603.spcon)
   e3:SetTarget(c95480603.sptg)
   e3:SetOperation(c95480603.spop)
   c:RegisterEffect(e3)
   e1:SetLabelObject(e3)
   e2:SetLabelObject(e3)
end
function c95480603.filter(c)
   return c:IsSetCard(0xd57) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c95480603.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chk==0 then return Duel.IsExistingMatchingCard(c95480603.filter,tp,LOCATION_DECK,0,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c95480603.rmop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
   local g=Duel.SelectMatchingCard(tp,c95480603.filter,tp,LOCATION_DECK,0,1,1,nil)
   local tc=g:GetFirst()
   local c=e:GetHandler()
   if tc then
      Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
      if c:IsRelateToEffect(e) then
         c:RegisterFlagEffect(95480603,RESET_EVENT+0x1680000,0,0)
         tc:RegisterFlagEffect(95480603,RESET_EVENT+0x1680000,0,0)
         e:GetLabelObject():SetLabelObject(tc)
      end
   end
end
function c95480603.spcon(e,tp,eg,ep,ev,re,r,rp)
   local tc=e:GetLabelObject()
   local c=e:GetHandler()
   return tc and c:IsPreviousLocation(LOCATION_ONFIELD)
      and c:GetFlagEffect(95480603)~=0 and c:IsLocation(LOCATION_GRAVE)
end
function c95480603.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   local tc=e:GetLabelObject()
   if chk==0 then return tc:GetFlagEffect(95480603)~=0 end
   tc:CreateEffectRelation(e)
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c95480603.spop(e,tp,eg,ep,ev,re,r,rp)
   local tc=e:GetLabelObject()
   if tc:IsRelateToEffect(e) then
      Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
   end
end
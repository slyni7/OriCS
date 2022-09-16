--영매술 윤회
function c95480921.initial_effect(c)
   --Activate
   local e1=Effect.CreateEffect(c)
   e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
   e1:SetType(EFFECT_TYPE_ACTIVATE)
   e1:SetCode(EVENT_FREE_CHAIN)
   e1:SetCountLimit(1,95480921+EFFECT_COUNT_CODE_OATH)
   e1:SetTarget(c95480921.target)
   e1:SetOperation(c95480921.activate)
   c:RegisterEffect(e1)
end
function c95480921.rfilter(c)
   return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReleasableByEffect()
end
function c95480921.filter(c,e,tp,m)
   if not c:IsSetCard(0xd42) or bit.band(c:GetType(),0x81)~=0x81
      or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) then return false end
   local mg=nil
   if c.mat_filter then
      mg=m:Filter(c.mat_filter,c)
   else
      mg=m:Clone()
      mg:RemoveCard(c)
   end
   return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c95480921.mfilter(c)
   return c:IsSetCard(0xd42) and c:IsAbleToGrave() and c:IsFaceup()
end
function c95480921.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then
      local mg1=Duel.GetRitualMaterial(tp)
      local mg2=Duel.GetMatchingGroup(c95480921.mfilter,tp,LOCATION_EXTRA,0,nil)
      mg1:Merge(mg2)
      return Duel.IsExistingMatchingCard(c95480921.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1)
   end
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c95480921.activate(e,tp,eg,ep,ev,re,r,rp)
   local mg1=Duel.GetRitualMaterial(tp)
   local mg2=Duel.GetMatchingGroup(c95480921.mfilter,tp,LOCATION_EXTRA,0,nil)
   mg1:Merge(mg2)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   local tg=Duel.SelectMatchingCard(tp,c95480921.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1)
   if tg:GetCount()>0 then
      local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if tc.mat_filter then
				mg1=mg1:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat1=mg1:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat1)
		local mat2=mat1:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		mat1:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat1)
		Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

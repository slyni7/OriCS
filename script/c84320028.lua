--샤를로트-비밀의 서
function c84320028.initial_effect(c)
	aux.AddCodeList(c,84320025)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,84320028)
	e1:SetTarget(c84320028.target)
	e1:SetOperation(c84320028.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(84320028,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c84320028.thcost)
	e2:SetTarget(c84320028.thtg)
	e2:SetOperation(c84320028.thop)
	c:RegisterEffect(e2)
end
function c84320028.filter(c,e,tp,m)
   if not c:IsSetCard(0x7a1) or bit.band(c:GetType(),0x81)~=0x81
      or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
   local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
   if c.mat_filter then
      mg=mg:Filter(c.mat_filter,nil)
   end
   return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function c84320028.mfilter(c)
   return c:IsType(TYPE_MONSTER)
end
function c84320028.cfilter(c)
   return c:GetSummonLocation()==LOCATION_EXTRA
end
function c84320028.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then
      local m=Duel.GetRitualMaterial(tp)
      local m2=Duel.GetMatchingGroup(c84320028.mfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil)
      if Duel.IsExistingMatchingCard(c84320028.cfilter,tp,0,LOCATION_MZONE,1,nil) then
         m:Merge(m2)
      end
      return Duel.IsExistingMatchingCard(c84320028.filter,tp,LOCATION_HAND,0,1,nil,e,tp,m)
   end
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c84320028.activate(e,tp,eg,ep,ev,re,r,rp)
   local m=Duel.GetRitualMaterial(tp)
   local m2=Duel.GetMatchingGroup(c84320028.mfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil)
   if Duel.IsExistingMatchingCard(c84320028.cfilter,tp,0,LOCATION_MZONE,1,nil) then
      m:Merge(m2)
   end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   local tg=Duel.SelectMatchingCard(tp,c84320028.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,m)
   local tc=tg:GetFirst()
   if tc then
      local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
      if tc.mat_filter then
         mg=mg:Filter(tc.mat_filter,nil)
      end
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
      local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
      tc:SetMaterial(mat)
      local ex=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA+LOCATION_DECK)
      mat:Sub(ex)
      Duel.SendtoGrave(ex,REASON_EFFECT+REASON_RITUAL+REASON_MATERIAL)
      Duel.ReleaseRitualMaterial(mat)
      Duel.BreakEffect()
      Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
      tc:CompleteProcedure()
   end
end




function c84320028.thfilter(c)
	return c:IsSetCard(0x7a1) and c:IsAbleToRemoveAsCost()
end
function c84320028.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84320028.thfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c84320028.thfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c84320028.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c84320028.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
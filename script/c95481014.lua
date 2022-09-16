--아니마기아스 비뮤티
function c95481014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c95481014.target)
	e1:SetOperation(c95481014.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,95481014)
	e2:SetCondition(c95481014.thcon)
	e2:SetTarget(c95481014.thtg)
	e2:SetOperation(c95481014.thop)
	c:RegisterEffect(e2)
end

function c95481014.cfilter1(c,e,tp)
   return c:IsFaceup() and c:IsSetCard(0xd5e)
      and c:IsType(TYPE_TUNER) and c:IsAbleToGrave()
      and Duel.IsExistingMatchingCard(c95481014.cfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp,c)
end
function c95481014.cfilter2(c,e,tp,tc)
   return c:IsFaceup() and c:IsSetCard(0xd5e)
      and not c:IsType(TYPE_TUNER) and c:IsAbleToGrave()
      and Duel.IsExistingMatchingCard(c95481014.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,math.abs(c:GetLevel()-tc:GetLevel()),Group.FromCards(c,tc))
end
function c95481014.spfilter(c,e,tp,lv,mg)
   return c:IsType(TYPE_SYNCHRO) and c:GetLevel()==lv
      and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c95481014.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c95481014.cfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
   Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,2,tp,0,LOCATION_MZONE)
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c95481014.activate(e,tp,eg,ep,ev,re,r,rp)
   local dg=Group.CreateGroup()
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
   local g1=Duel.SelectMatchingCard(tp,c95481014.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
   if g1:GetFirst() then
      dg:AddCard(g1:GetFirst())
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
      local g2=Duel.SelectMatchingCard(tp,c95481014.cfilter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp,g1:GetFirst())
      if g2:GetFirst() then
         dg:AddCard(g2:GetFirst())
         local lv=math.abs(g1:GetFirst():GetLevel()-g2:GetFirst():GetLevel())
         if Duel.SendtoGrave(dg,REASON_EFFECT)==2 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=Duel.SelectMatchingCard(tp,c95481014.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
			local tc=g:GetFirst()
            if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
               tc:CompleteProcedure()
            end
         end
      end
   end
end

function c95481014.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c95481014.thfilter(c)
	return c:IsSetCard(0xd5e) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not c:IsCode(95481014)
end
function c95481014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481014.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95481014.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95481014.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
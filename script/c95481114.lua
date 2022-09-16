--구세의 파멸서약
function c95481114.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43034264,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd5c))
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9659580,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c95481114.thtg)
	e4:SetOperation(c95481114.thop)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(95481114)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c95481114.indtg)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c95481114.adjust)
	c:RegisterEffect(e5)
end
function c95481114.filter(c)
   return c:IsSetCard(0xd5c) and c:IsFaceup()
      and c:IsHasEffect(95481114)
      and c:GetFlagEffect(95481114)==0
end
function c95481114.adjust(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   local g=Duel.GetMatchingGroup(c95481114.filter,tp,LOCATION_ONFIELD,0,nil)
   if g:GetCount()>0 then
      local tc=g:GetFirst()
      while tc do
         local e1=Effect.CreateEffect(c)
         e1:SetType(EFFECT_TYPE_SINGLE)
         e1:SetCode(EFFECT_IMMUNE_EFFECT)
         e1:SetValue(c95481114.efilter)
         e1:SetReset(RESET_EVENT+0x1fe0000)
         e1:SetLabelObject(tc)
         tc:RegisterEffect(e1)
         local e2=Effect.CreateEffect(c)
         e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
         e2:SetCode(EVENT_ADJUST)
         e2:SetLabelObject(e1)
         e2:SetOperation(c95481114.reset)
         Duel.RegisterEffect(e2,tp)
         tc:RegisterFlagEffect(95481114,RESET_EVENT+0x1fe0000,0,0)
         tc=g:GetNext()
      end
   end
end
function c95481114.efilter(e,te)
   if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then
      local lv=e:GetHandler():GetLevel()
      local ec=te:GetOwner()
      if ec:IsType(TYPE_LINK) then
         return ec:GetLink()<lv
      elseif ec:IsType(TYPE_XYZ) then
         return ec:GetOriginalRank()<lv
      else
         return ec:GetOriginalLevel()<lv
      end
   else
      return false
   end
end
function c95481114.reset(e,tp,eg,ep,ev,re,r,rp)
   local te=e:GetLabelObject()
   local tc=te:GetLabelObject()
   if not tc:IsHasEffect(95481114) then
      tc:ResetFlagEffect(95481114)
      te:Reset()
      e:Reset()
   end
end
function c95481114.indtg(e,c)
	return c:IsSetCard(0xd5c)
end

function c95481114.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c95481114.spfilter(c,e,tp)
	return c:IsSetCard(0xd5c) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsLevelBelow(8)
end
function c95481114.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c95481114.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c95481114.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95481114.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end

function c95481114.thfilter(c)
	return c:IsSetCard(0xd5c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c95481114.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481114.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95481114.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95481114.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

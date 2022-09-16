--아니마기아스 리컨스트럭트
function c95481016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c95481016.target)
	e1:SetOperation(c95481016.activate)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49032236,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,95481016)
	e2:SetCondition(c95481016.condition)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c95481016.tg)
	e2:SetOperation(c95481016.op)
	c:RegisterEffect(e2)
end
function c95481016.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd5e)
end
function c95481016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c95481016.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95481016.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48976825,0))
	local g=Duel.SelectTarget(tp,c95481016.filter,tp,LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c95481016.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end
function c95481016.cfilter(c)
	return c:IsFaceup() and c:IsCode(95481011)
end
function c95481016.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c95481016.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and aux.exccon(e)
end
function c95481016.cfilter1(c,e,tp)
   return c:IsFaceup() and c:IsSetCard(0xd5e)
      and c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
      and Duel.IsExistingMatchingCard(c95481016.cfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c95481016.cfilter2(c,e,tp,tc)
   return c:IsFaceup() and c:IsSetCard(0xd5e)
      and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
      and Duel.IsExistingMatchingCard(c95481016.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,math.abs(c:GetLevel()-tc:GetLevel()),Group.FromCards(c,tc))
end
function c95481016.spfilter(c,e,tp,lv,mg)
   return c:IsType(TYPE_SYNCHRO) and c:GetLevel()==lv
      and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c95481016.tg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c95481016.cfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
   Duel.SetOperationInfo(0,CATEGORY_REMOVE,2,tp,0,LOCATION_GRAVE)
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c95481016.op(e,tp,eg,ep,ev,re,r,rp)
   local dg=Group.CreateGroup()
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
   local g1=Duel.SelectMatchingCard(tp,c95481016.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
   if g1:GetFirst() then
      dg:AddCard(g1:GetFirst())
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
      local g2=Duel.SelectMatchingCard(tp,c95481016.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,g1:GetFirst())
      if g2:GetFirst() then
         dg:AddCard(g2:GetFirst())
         local lv=math.abs(g1:GetFirst():GetLevel()-g2:GetFirst():GetLevel())
         if Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)==2 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=Duel.SelectMatchingCard(tp,c95481016.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,lv)
			local tc=g:GetFirst()
            if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
               tc:CompleteProcedure()
            end
         end
      end
   end
end
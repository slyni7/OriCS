--샤를로트-사키엘
function c84320022.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84320022,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,84320022)
	e1:SetCost(c84320022.cost)
	e1:SetTarget(c84320022.tg)
	e1:SetOperation(c84320022.op)
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
	e3:SetCondition(c84320022.condition2)
	e3:SetCost(c84320022.cost2)
	e3:SetTarget(c84320022.target2)
	e3:SetOperation(c84320022.activate2)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(84320022,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,84320122)
	e4:SetTarget(c84320022.rettg)
	e4:SetOperation(c84320022.retop)
	c:RegisterEffect(e4)
end


function c84320022.filter1(c,e,tp)
	return c:IsSetCard(0x7a1) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not (c:IsCode(84320053) and c:IsCode(84320054))
end
function c84320022.filter2(c,e,tp)
	return c:IsSetCard(0x7a1) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not (c:IsCode(84320053) and c:IsCode(84320054))
end
function c84320022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c84320022.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsEnvironment(84320029) then
			return Duel.IsExistingMatchingCard(c84320022.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
		return Duel.IsExistingMatchingCard(c84320022.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE,e,tp)
end
function c84320022.op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
   local g=nil
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   if not Duel.IsEnvironment(84320029) then
      g=Duel.SelectMatchingCard(tp,c84320022.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
   else g=Duel.SelectMatchingCard(tp,c84320022.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil,e,tp) end
   if g:GetCount()~=0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
   local c=e:GetHandler()
   local tc=g:GetFirst()
   while tc do
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_FIELD)
   e1:SetCode(EFFECT_CANNOT_ATTACK)
   e1:SetTargetRange(LOCATION_MZONE,0)
   e1:SetTarget(c84320022.atktg)
   e1:SetReset(RESET_PHASE+PHASE_END)
   Duel.RegisterEffect(e1,tp)
   local e2=Effect.CreateEffect(c)
   e2:SetType(EFFECT_TYPE_SINGLE)
   e2:SetCode(EFFECT_DISABLE)
   e2:SetReset(RESET_EVENT+0xfe0000)
   tc:RegisterEffect(e2)
   local e3=Effect.CreateEffect(c)
   e3:SetType(EFFECT_TYPE_SINGLE)
   e3:SetCode(EFFECT_DISABLE_EFFECT)
   e3:SetReset(RESET_EVENT+0xfe0000)
   tc:RegisterEffect(e3)
      tc=g:GetNext()
   end
   end
end
function c84320022.atktg(e,c)
	return not c:IsSetCard(0x7a1)
end





function c84320022.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c84320022.drcofilter(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsDestructable()
end
function c84320022.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84320022.drcofilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c84320022.drcofilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c84320022.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c84320022.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end




function c84320022.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c84320022.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end

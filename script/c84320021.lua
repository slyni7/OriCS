--샤를로트-사하퀴엘
function c84320021.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84320021,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,84320021)
	e1:SetTarget(c84320021.tg)
	e1:SetOperation(c84320021.op)
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
	e3:SetCondition(c84320021.condition2)
	e3:SetCost(c84320021.cost2)
	e3:SetTarget(c84320021.target2)
	e3:SetOperation(c84320021.activate2)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(84320021,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,84320121)
	e4:SetTarget(c84320021.rettg)
	e4:SetOperation(c84320021.retop)
	c:RegisterEffect(e4)
end


function c84320021.filter1(c)
	return c:IsSetCard(0x7a1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c84320021.filter2(c)
	return c:IsSetCard(0x7a1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c84320021.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsEnvironment(84320029) then
			return Duel.IsExistingMatchingCard(c84320021.filter1,tp,LOCATION_DECK,0,1,nil) end
		return Duel.IsExistingMatchingCard(c84320021.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c84320021.op(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if not Duel.IsEnvironment(84320029) then
		g=Duel.SelectMatchingCard(tp,c84320021.filter1,tp,LOCATION_DECK,0,1,1,nil)
	else g=Duel.SelectMatchingCard(tp,c84320021.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil) end
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end




function c84320021.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c84320021.drcofilter(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsDestructable()
end
function c84320021.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84320021.drcofilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c84320021.drcofilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c84320021.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c84320021.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end



function c84320021.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c84320021.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end

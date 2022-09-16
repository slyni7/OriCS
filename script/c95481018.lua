--아니마기아스 스발린
function c95481018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c95481018.condition)
	e1:SetTarget(c95481018.target)
	e1:SetOperation(c95481018.activate)
	c:RegisterEffect(e1)
end
function c95481018.cfilter(c)
	return c:IsFaceup() and c:IsCode(95481011)
end
function c95481018.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c95481018.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c95481018.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c95481018.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c95481018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c95481018.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
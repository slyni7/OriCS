--C1tY Pop(나이트 스케이프) 플랑크 에너지
local s,id=GetID()
function s.initial_effect(c)
	--Activate(effect)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(s.condition)
	e4:SetTarget(s.target)
	e4:SetOperation(s.activate)
	c:RegisterEffect(e4)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return false end
	if not Duel.IsChainDisablable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.filter(c)
	return (c:IsSetCard(0xe74) or c:IsSetCard(0x72)) and c:IsMonster()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.SendtoDeck(g,nil,-2,REASON_EFFECT)>0 and Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

--유키-이어지는 사건
function c84320008.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),2,2,c84320008.pfun1)
	--counter
	 local e1=Effect.CreateEffect(c)
	 e1:SetDescription(aux.Stringid(84320008,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	 e1:SetOperation(c84320008.operation)
	 c:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c84320008.val)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84320008,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c84320008.atkcon)
	e1:SetOperation(c84320008.atkop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetCondition(c84320008.con)
	e3:SetValue(c84320008.atkval)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e5:SetValue(c84320008.defval)
	c:RegisterEffect(e5)
end
function c84320008.pfun1(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x7a0)
end
function c84320008.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1234,1)
		tc=g:GetNext()
	end
end
function c84320008.val(e,c)
	return Duel.GetCounter(0,1,1,0x1234)*100
end
function c84320008.cfilter(c,g)
	return c:IsFaceup() and g:IsContains(c) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c84320008.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(c84320008.cfilter,1,nil,lg)
end
function c84320008.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if not lg then return end
	local g=eg:Filter(c84320008.cfilter,nil,lg)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c84320008.con(e,c)
	return Duel.GetCounter(0,1,1,0x1234)>0
end
function c84320008.atkval(e,c)
	return math.ceil(c:GetAttack()/2)
end
function c84320008.defval(e,c)
	return math.ceil(c:GetDefense()/2)
end

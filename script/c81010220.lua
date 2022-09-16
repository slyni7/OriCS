--MMJ : Tomare!

function c81010220.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,81010220)
	e1:SetCondition(c81010220.actcn)
	e1:SetTarget(c81010220.acttg)
	e1:SetCost(c81010220.actco)
	e1:SetOperation(c81010220.actop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c81010220.hdcn)
	c:RegisterEffect(e2)

end

--Activate
function c81010220.hdcn(e)
	return Duel.GetMatchingGroupCount(c81010220.actcnfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)>=3
end
function c81010220.actcnfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca1)
end

function c81010220.actcn(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) 
		and Duel.IsChainNegatable(ev)
end

function c81010220.actcofilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca1) and c:IsReleasable()
		and not c:IsStatus(STATUS_BATTLE_DESTROY)
end
function c81010220.actco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010220.actcofilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81010220.actcofilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function c81010220.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function c81010220.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

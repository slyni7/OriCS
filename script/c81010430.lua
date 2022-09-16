--White Wolf "Onigarasu"

function c81010430.initial_effect(c)

	--summon method
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEASTWARRIOR),2,2,c81010430.mfilter)
	c:EnableReviveLimit()
	
	--limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c81010430.lmcn)
	e1:SetTargetRange(0,1)
	e1:SetValue(c81010430.lmvl)
	c:RegisterEffect(e1)
	
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010430,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81010430.ngcn)
	e2:SetCost(c81010430.ngco)
	e2:SetTarget(c81010430.ngtg)
	e2:SetOperation(c81010430.ngop)
	c:RegisterEffect(e2)
end

--summon method
function c81010430.mfilter(g,lc)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND)
end

--limit
function c81010430.lmcn(e)
	return Duel.GetAttacker()==e:GetHandler()
	    or Duel.GetAttackTarget()==e:GetHandler()
end
function c81010430.lmvl(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

--negate
function c81010430.ngcn(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER)	and Duel.IsChainDisablable(ev)
end

function c81010430.ngcofilter(c)
	return c:IsSetCard(0xca1) and c:IsAbleToDeckAsCost()
end
function c81010430.ngco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81010430.ngcofilter,tp,LOCATION_GRAVE,0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c81010430.ngcofilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

function c81010430.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end

function c81010430.ngop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

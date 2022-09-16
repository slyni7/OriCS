--샤를로트-메르카바
function c84320027.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,84320027)
	e1:SetCost(c84320027.cost)
	e1:SetTarget(c84320027.target)
	e1:SetOperation(c84320027.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c84320027.reptg)
	e2:SetValue(c84320027.repval)
	e2:SetOperation(c84320027.repop)
	c:RegisterEffect(e2)
end
function c84320027.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsSetCard,1,e:GetHandler(),0x7a1) end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsSetCard,1,1,e:GetHandler(),0x7a1)
	Duel.Release(g,REASON_COST)
end
function c84320027.cfilter(c)
	return c:IsSetCard(0x7a1) and c:IsType(TYPE_MONSTER)
end
function c84320027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84320027.cfilter,tp,LOCATION_MZONE,0,1,nil) end
end

function c84320027.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c84320027.indtg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
end
function c84320027.indtg(e,c)
	return c:IsSetCard(0x7a1) and c:IsLocation(LOCATION_MZONE)
end

function c84320027.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x7a1) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c84320027.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c84320027.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(84320027,0))
end
function c84320027.repval(e,c)
	return c84320027.repfilter(c,e:GetHandlerPlayer())
end
function c84320027.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
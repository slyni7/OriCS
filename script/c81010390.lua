--데몬 서브젝트

function c81010390.initial_effect(c)

	--summon method
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xca1),1)

	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c81010390.atcn)
	e3:SetValue(c81010390.atlm)
	c:RegisterEffect(e3)
	
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c81010390.ngcn)
	e4:SetCost(c81010390.ngco)
	e4:SetTarget(c81010390.ngtg)
	e4:SetOperation(c81010390.ngop)
	c:RegisterEffect(e4)
	
end

--act limit
function c81010390.atcn(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

function c81010390.atlm(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

--negate
function c81010390.ngcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:GetHandler()~=c
	and not c:IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev)
end

function c81010390.ngcofilter(c,typ)
	return c:IsType(typ) and c:IsDiscardable()
end
function c81010390.ngco(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISCARD_COST_CHANGE) then return true end
	local typ=0
		if re:IsActiveType(TYPE_MONSTER) then typ=TYPE_MONSTER
	elseif re:IsActiveType(TYPE_SPELL) then typ=TYPE_SPELL else typ=TYPE_TRAP end
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81010390.ngcofilter,tp,LOCATION_HAND,0,1,nil,typ)
			end
	Duel.DiscardHand(tp,c81010390.ngcofilter,1,1,REASON_COST+REASON_DISCARD,nil,typ)
end

function c81010390.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end

function c81010390.ngop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end

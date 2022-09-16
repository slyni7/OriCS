--천승자 헤트
function c95481509.initial_effect(c)
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99668578,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95481509)
	e1:SetTarget(c95481509.target)
	e1:SetOperation(c95481509.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c95481509.effcon)
	e3:SetOperation(c95481509.effop)
	c:RegisterEffect(e3)
end
function c95481509.filter(c)
	return c:IsSetCard(0xd55)
end
function c95481509.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c95481509.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c95481509.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c95481509.filter,1,1,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

function c95481509.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and not e:GetHandler():GetReasonCard():IsType(TYPE_EFFECT)
end
function c95481509.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(95481509,1))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c95481509.negcon)
	e1:SetTarget(c95481509.negtg)
	e1:SetOperation(c95481509.negop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetValue(TYPE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e2,true)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95481509,2))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0xd55)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e3,true)
end
function c95481509.negcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
		and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c95481509.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c95481509.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end

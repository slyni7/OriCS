--플랑크 익스텐디드
local m=112604159
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,"<",nil
		,aux.FilterBoolFunction(Card.IsLevel,1)
		,aux.FilterBoolFunction(Card.IsAttack,1)
		,aux.FilterBoolFunction(Card.IsDefense,1))
	--Cannot be destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.damcon)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(Duel.IsMainPhase)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
cm.listed_series={0xe74}
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp or not re:GetHandler():IsSetCard(0xe74) then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp or not re:GetHandler():IsSetCard(0xe74) and c:GetFlagEffect(m)~=0 
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-100)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_HAND+LOCATION_GRAVE)
	e1:SetTarget(cm.distarget)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetOperation(cm.disop1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.disop1(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local rc=re:GetHandler()
	if (loc==LOCATION_GRAVE or loc==LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER)
		and rc:IsAttackAbove(2) then
		Duel.NegateEffect(ev)
	end
end
function cm.distarget(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsAttackAbove(2)
end
function cm.immop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(0xff,0)
	e1:SetTarget(cm.tfilter)
	e1:SetValue(cm.efilter)
	if Duel.GetCurrentPhase()==PHASE_MAIN1 then
		e1:SetReset(RESET_PHASE+PHASE_MAIN1)
	else
		e1:SetReset(RESET_PHASE+PHASE_MAIN2)
	end
	Duel.RegisterEffect(e1,tp)
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_MONSTER)
end
function cm.tfilter(e,c)
	return c:IsSetCard(0xe74) and c:IsMonster()
end
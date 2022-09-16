--천명신 퓨도르
function c95480310.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_FIEND),6,3)
	c:EnableReviveLimit()
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetCondition(c95480310.con)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c95480310.aclimit)
	c:RegisterEffect(e1)
	--negate activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49456901,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c95480310.condition)
	e2:SetCost(c95480310.cost)
	e2:SetTarget(c95480310.target)
	e2:SetOperation(c95480310.operation)
	c:RegisterEffect(e2)
end
function c95480310.con(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_BATTLE or ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL
end
function c95480310.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c95480310.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
		and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c95480310.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c95480310.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c95480310.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0
		and Duel.SelectYesNo(tp,aux.Stringid(95480310,0)) then
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(1-tp,1)
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end


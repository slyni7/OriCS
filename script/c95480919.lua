--¿µ¸ÅÈñ ÅÙ±¸
function c95480919.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86238081,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,95480919)
	e1:SetCost(c95480919.cost)
	e1:SetTarget(c95480919.pctg)
	e1:SetOperation(c95480919.pcop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.ritlimit)
	c:RegisterEffect(e4)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_PZONE,0)
	e2:SetValue(c95480919.indct)
	c:RegisterEffect(e2)
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c95480919.condition)
	e1:SetOperation(c95480919.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c95480919.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c95480919.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c95480919.valcheck(e,c)
	e:GetLabelObject():SetLabel(c:GetMaterial():FilterCount(Card.IsType,nil,TYPE_PENDULUM))
end
function c95480919.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c95480919.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if ct>=2 then
		local e1=Effect.CreateEffect(c)
		--e1:SetDescription(aux.Stringid(95480919,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		--e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(ct-1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c95480919.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd42) and c:IsAbleToGraveAsCost()
end
function c95480919.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480919.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c95480919.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c95480919.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xd42) and not c:IsCode(95480919) and not c:IsForbidden()
end
function c95480919.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c95480919.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c95480919.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c95480919.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c95480919.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c95480919.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c95480919.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0xd42)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)) and not c:IsReason(REASON_REPLACE)
end
function c95480919.desfilter(c,e,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_HAND+LOCATION_MZONE+LOCATION_PZONE) and c:IsSetCard(0xd42)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c95480919.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c95480919.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c95480919.desfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_PZONE,0,1,nil,e,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c95480919.desfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_PZONE,0,1,1,nil,e,tp)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	return false
end
function c95480919.repval(e,c)
	return c95480919.repfilter(c,e:GetHandlerPlayer())
end
function c95480919.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end

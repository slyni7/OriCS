--MMJ5re
function c81010040.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c81010040.alvl)
	e1:SetCondition(c81010040.alcon)
	c:RegisterEffect(e1)
	--ATK up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c81010040.atcon)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
end

--act limit
function c81010040.alvl(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c81010040.alcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

--ATK up
function c81010040.atcon(e)
	local ph=Duel.GetCurrentPhase()
	if not (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) or not e:GetHandler():IsRelateToBattle() then return false end
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsFaceup() and bc:IsAttackAbove(2500)
end

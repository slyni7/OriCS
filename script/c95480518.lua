--드라코센드 이피우커스
function c95480518.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c95480518.matfilter,2)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c95480518.imcon)
	e1:SetValue(c95480518.efilter)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(c95480518.con)
	e2:SetValue(c95480518.tg)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c95480518.con)
	e3:SetTarget(c95480518.tg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c95480518.discon)
	e4:SetTarget(c95480518.distg)
	e4:SetOperation(c95480518.disop)
	c:RegisterEffect(e4)
end
function c95480518.matfilter(c)
	return c:IsLinkSetCard(0xd5b) and c:IsLinkType(TYPE_LINK)
end
function c95480518.imcon(e)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c95480518.efilter(e,te)
	return not te:GetOwner():IsSetCard(0xd5b)
end
function c95480518.con(e)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c95480518.tg(e,c)
	return c:GetMutualLinkedGroupCount()>0 and not c:IsCode(95480518)
end
function c95480518.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c95480518.cfilter(c)
	return c:GetMutualLinkedGroupCount()>0 and c:IsRace(RACE_WYRM)
end
function c95480518.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c95480518.cfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return c:GetFlagEffect(95480518)<ct end
	c:RegisterFlagEffect(95480518,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) and re:GetHandler()~=c then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c95480518.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--드라코센드 비르고
function c95480509.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WYRM),2,2)
	c:EnableReviveLimit()
	--dam
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c95480509.damcon1)
	e1:SetOperation(c95480509.damop1)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c95480509.regcon)
	e2:SetOperation(c95480509.regop)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c95480509.damcon2)
	e3:SetOperation(c95480509.damop2)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
	--avoid battle damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(c95480509.indcon)
	e4:SetTarget(c95480509.indtg)
	e4:SetValue(1,0)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77539547,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,95480509)
	e5:SetCondition(c95480509.descon)
	e5:SetTarget(c95480509.destg)
	e5:SetOperation(c95480509.desop)
	c:RegisterEffect(e5)
end
function c95480509.filter(c,sp)
	return c:GetSummonPlayer()==sp
end
function c95480509.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95480509.filter,1,nil,1-tp) and e:GetHandler():GetMutualLinkedGroupCount()>0
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c95480509.damop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c95480509.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95480509.filter,1,nil,1-tp) and e:GetHandler():GetMutualLinkedGroupCount()>0
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c95480509.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,95480509,RESET_CHAIN,0,1)
end
function c95480509.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,95480509)>0 and e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c95480509.damop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,95480509)
	Duel.ResetFlagEffect(tp,95480509)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c95480509.indtg(e,c)
	return c:GetMutualLinkedGroupCount()>0
end
function c95480509.indcon(e)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c95480509.descon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc~=e:GetHandler() and rc:GetLinkedGroup():IsContains(e:GetHandler())
end
function c95480509.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c95480509.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

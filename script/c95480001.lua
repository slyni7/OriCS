--외신 요그조트
function c95480001.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,5,5,c95480001.pfil1,aux.Stringid(95480001,0))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c95480001.con2)
	e2:SetOperation(c95480001.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95480001,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c95480001.con3)
	e3:SetCost(c95480001.cost3)
	e3:SetTarget(c95480001.tar3)
	e3:SetOperation(c95480001.op3)
	c:RegisterEffect(e3)
end
function c95480001.pfil1(c)
	return c:IsFaceup() and c:IsSetCard(0xb6) and c:IsType(TYPE_XYZ)
end
function c95480001.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c95480001.ofil2(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT)) and not c:IsDisabled()
end
function c95480001.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c95480001.ofil2,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local fid=c:GetFieldID()
	local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_SZONE,nil)
	if sg:GetCount()==0 then
		return
	end
	local sc=sg:GetFirst()
	while sc do
		sc:RegisterFlagEffect(95480001,RESET_EVENT+RESETS_STANDARD,0,0,fid)
		sc=g:GetNext()
	end
	sg:KeepAlive()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)	
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	e3:SetLabelObject(sg)
	e3:SetLabel(fid)
	e3:SetTargetRange(0,LOCATION_SZONE)
	e3:SetTarget(c95480001.otar23)
	c:RegisterEffect(e3)
end
function c95480001.otar23(e,c)
	local fid=e:GetLabel()
	local sg=e:GetLabelObject()
	return sg:IsContains(c) and c:GetFlagEffectLabel(95480001)==fid
end
function c95480001.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	return g:IsExists(Card.IsType,1,nil,TYPE_FUSION) and g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
		and g:IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
function c95480001.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,3,REASON_COST)
	end
	c:RemoveOverlayCard(tp,3,3,REASON_COST)
end
function c95480001.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN)
	end
end
function c95480001.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
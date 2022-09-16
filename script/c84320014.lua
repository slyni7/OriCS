--히든 유키 폭탄
function c84320014.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c84320014.damcost)
	e1:SetTarget(c84320014.damtg)
	e1:SetOperation(c84320014.damop)
	c:RegisterEffect(e1)
end
function c84320014.filter(c)
	return c:GetCounter(0x1234)>0
end
function c84320014.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84320014.filter,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c84320014.filter,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil)
	local tc=g:GetFirst()
	local s=0
	while tc do
		local ct=tc:GetCounter(0x1234)
		s=s+ct
		tc:RemoveCounter(tp,0x1234,ct,REASON_COST)
		tc=g:GetNext()
	end
	e:SetLabel(s*300)
end
function c84320014.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
end
function c84320014.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

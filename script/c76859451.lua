--언인스톨
function c76859451.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetCountLimit(1,76859451+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c76859451.cost1)
	e1:SetCondition(c76859451.con1)
	e1:SetTarget(c76859451.tar1)
	e1:SetOperation(c76859451.op1)
	c:RegisterEffect(e1)
	if not c76859451.glo_chk then
		c76859451.glo_chk=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(c76859451.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function c76859451.gop1(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetCurrentChain()
	if cid>0 and bit.band(r,REASON_COST)>0 then
		c76859451[cid]=true
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetLabel(cid)
		e1:SetOperation(c76859451.gop11)
		Duel.RegisterEffect(e1,0)
	end
end
function c76859451.gop11(e,tp,eg,ep,ev,re,r,rp)
	local cid=e:GetLabel()
	c76859451[cid]=false
end
function c76859451.con1(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	return Duel.IsChainNegatable(ev) and rp~=tp
		and ((re:IsHasCategory(CATEGORY_DRAW) or re:IsHasCategory(CATEGORY_SEARCH))
			or (v and bit.band(v,LOCATION_DECK)>0)
			or c76859451[ev])
end
function c76859451.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,1600)
	end
	Duel.PayLPCost(tp,1600)
end
function c76859451.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local rc=re:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c76859451.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.NegateActivation(ev)
	if rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
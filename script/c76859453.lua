--인스톨 안젤리카
function c76859453.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCountLimit(1,76859453)
	e1:SetCost(c76859453.cost1)
	e1:SetTarget(c76859453.tg1)
	e1:SetOperation(c76859453.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCountLimit(1,76859454)
	e2:SetCost(c76859453.cost1)
	e2:SetTarget(c76859453.tg1)
	e2:SetOperation(c76859453.op1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	if not c76859453.global_check then
		c76859453.global_check=true
		c76859453[0]=true
		c76859453[1]=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c76859453.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c76859453.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c76859453.gop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsSetCard(0x2c1) then
			c76859453[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c76859453.gop2(e,tp,eg,ep,ev,re,r,rp)
	c76859453[0]=true
	c76859453[1]=true
end
function c76859453.cfilter1(c)
	return c:IsSetCard(0x2c1) and c:IsDiscardable() and not c:IsCode(76859453)
end
function c76859453.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c76859453[tp] and Duel.IsExistingMatchingCard(c76859453.cfilter1,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c76859453.cfilter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c76859453.tfilter11)
	Duel.RegisterEffect(e1,tp)
end
function c76859453.tfilter11(e,c)
	return not c:IsSetCard(0x2c1)
end
function c76859453.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c76859453.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
end
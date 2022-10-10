--인스톨라이제이션
function c76859433.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,76859433+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetOperation(c76859433.op1)
	c:RegisterEffect(e1)
	if not c76859433.global_check then
		c76859433.global_check=true
		c76859433[0]=0
		c76859433[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(c76859433.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TO_HAND)
		ge2:SetOperation(c76859433.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c76859433.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c76859433.op11)
	Duel.RegisterEffect(e1,tp)
end
function c76859433.op11(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,76859433)
	Duel.Draw(tp,c76859433[tp],REASON_EFFECT)
end
function c76859433.gop1(e,tp,eg,ep,ev,re,r,rp)
	c76859433[0]=0
	c76859433[1]=0
end
function c76859433.gop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not re then
		return
	end
	local rc=re:GetHandler()
	if not rc:IsSetCard(0x2c1) then
		return
	end
	while tc do
		if not tc:IsReason(REASON_DRAW) and tc:IsReason(REASON_EFFECT) and tc:IsSetCard(0x2c1) and tc:GetReasonPlayer()==tc:GetControler() then
			local p=tc:GetReasonPlayer()
			c76859433[p]=c76859433[p]+1
		end
		tc=eg:GetNext()
	end
end
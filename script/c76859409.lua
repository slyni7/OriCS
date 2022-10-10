--인스톨 입실론
function c76859409.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2c1),4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,76859409)
	e1:SetCost(c76859409.cost1)
	e1:SetTarget(c76859409.tg1)
	e1:SetOperation(c76859409.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e2:SetCountLimit(1,76859410)
	e2:SetCost(c76859409.cost2)
	e2:SetTarget(c76859409.tg2)
	e2:SetOperation(c76859409.op2)
	c:RegisterEffect(e2)
	if not c76859409.global_check then
		c76859409.global_check=true
		c76859409[0]=true
		c76859409[1]=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c76859409.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c76859409.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c76859409.gop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsSetCard(0x2c1) then
			c76859409[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c76859409.gop2(e,tp,eg,ep,ev,re,r,rp)
	c76859409[0]=true
	c76859409[1]=true
end
function c76859409.cfilter1(c)
	return c:IsSetCard(0x2c1) and c:IsAbleToRemoveAsCost() and not c:IsCode(76859409)
end
function c76859409.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c76859409[tp] and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c76859409.tfilter11)
	Duel.RegisterEffect(e1,tp)
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c76859409.tfilter11(e,c)
	return not c:IsSetCard(0x2c1)
end
function c76859409.tfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x2c1) and not c:IsCode(76859409)
end
function c76859409.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingTarget(c76859409.tfilter1,tp,LOCATION_MZONE,0,1,nil)
	end
	local g=Duel.SelectTarget(tp,c76859409.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c76859409.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c76859409.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c76859409[tp]
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c76859409.tfilter11)
	Duel.RegisterEffect(e1,tp)
end
function c76859409.tfilter2(c)
	return c:IsSetCard(0x2c1) and c:IsAbleToDeck() and not c:IsCode(76859409) and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function c76859409.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingTarget(c76859409.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c76859409.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*300)
end
function c76859409.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if ct>0 then
		Duel.Recover(tp,ct*100,REASON_EFFECT)
	end
end
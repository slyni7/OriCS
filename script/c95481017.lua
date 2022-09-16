--아니마기아스 궁그닐
function c95481017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95481017)
	e1:SetCondition(c95481017.condition)
	e1:SetTarget(c95481017.target)
	e1:SetOperation(c95481017.activate)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49032236,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c95481017.tg)
	e2:SetOperation(c95481017.op)
	c:RegisterEffect(e2)
end
function c95481017.cfilter(c)
	return c:IsFaceup() and c:IsCode(95481011)
end
function c95481017.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c95481017.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c95481017.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c95481017.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c95481017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c95481017.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly(c)
		if not tc:IsImmuneToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e3:SetTarget(c95481017.distg)
			e3:SetLabel(tc:GetOriginalCodeRule())
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetCode(EVENT_CHAIN_SOLVING)
			e4:SetCondition(c95481017.discon)
			e4:SetOperation(c95481017.disop)
			e4:SetLabel(tc:GetOriginalCodeRule())
			e4:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e4,tp)
		end
	end
end
function c95481017.distg(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function c95481017.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return re:IsActiveType(TYPE_MONSTER) and (code1==code or code2==code)
end
function c95481017.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.NegateEffect(ev)
end

function c95481017.imfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c95481017.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c95481017.imfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c95481017.imfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c95481017.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c95481017.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c95481017.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end


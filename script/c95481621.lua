--로타이니 아스트로지아
function c95481621.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xd4f),c95481621.ffilter2,false)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75878039,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c95481621.target)
	e1:SetOperation(c95481621.operation)
	c:RegisterEffect(e1)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22091647,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,95481621)
	e3:SetCondition(c95481621.negcon)
	e3:SetCost(c95481621.negcost)
	e3:SetTarget(c95481621.negtg)
	e3:SetOperation(c95481621.negop)
	c:RegisterEffect(e3)
end


function c95481621.ffilter2(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsLocation(LOCATION_MZONE)
end
function c95481621.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,TYPE_MONSTER)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c95481621.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c95481621.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(1000)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(95481621,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end
function c95481621.eqlimit(e,c)
	return e:GetOwner()==c
end
function c95481621.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c95481621.costfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsAbleToRemoveAsCost() and c:GetFlagEffect(95481621)>0
end
function c95481621.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481621.costfilter2,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c95481621.costfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c95481621.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToChangeControler() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,eg,1,0,0)
	end
end
function c95481621.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		local tc=eg:GetFirst()
		if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		if not Duel.Equip(tp,tc,c) then return end
		tc:RegisterFlagEffect(95481621,RESET_EVENT+RESETS_STANDARD,0,0)
		e:SetLabelObject(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(c95481621.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		end
	end
end
function c95481621.eqlimit(e,c)
	return e:GetOwner()==c
end
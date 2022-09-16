--영원의 비전술
function c95482007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95482007+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c95482007.cost1)
	e1:SetTarget(c95482007.tar1)
	e1:SetOperation(c95482007.op1)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(95482007,ACTIVITY_CHAIN,c95482007.afil1)
end
function c95482007.afil1(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0xd40) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY)
end
function c95482007.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetCustomActivityCount(95482007,tp,ACTIVITY_CHAIN)<3
	end
end
function c95482007.tfil1(c)
	return c:IsSetCard(0xd40) and (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and not c:IsCode(95482007) and c:IsAbleToGrave()
end
function c95482007.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c95482007.tfil1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c95482007.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c95482007.tfil1,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
		local ct=Duel.GetCustomActivityCount(95482007,tp,ACTIVITY_CHAIN)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			ct=ct-1
		end
		if ct>=1 or ct>=2 then
		local ae=tc:GetActivateEffect()
			if ct>=1 then
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_QUICK_O)
				e1:SetCode(EVENT_FREE_CHAIN)
				e1:SetRange(LOCATION_GRAVE)
				e1:SetCountLimit(1)
				e1:SetDescription(ae:GetDescription())
				e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
				e1:SetTarget(c95482007.otar11)
				e1:SetOperation(c95482007.oop11)
				tc:RegisterEffect(e1)
			end
			if ct>=2 then
				local e2=Effect.CreateEffect(tc)
				e2:SetType(EFFECT_TYPE_QUICK_O)
				e2:SetCode(EVENT_FREE_CHAIN)
				e2:SetRange(LOCATION_GRAVE)
				e2:SetCountLimit(1)
				e2:SetDescription(ae:GetDescription())
				e2:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END)
				e2:SetTarget(c95482007.otar11)
				e2:SetOperation(c95482007.oop11)
				tc:RegisterEffect(e2)
			end
		end
	end
end
function c95482007.otar11(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ae=c:GetActivateEffect()
	local ftg=ae:GetTarget()
	if chk==0 then
		return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	if ae:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else
		e:SetProperty(0)
	end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c95482007.oop11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ae=c:GetActivateEffect()
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function c95482007.ocon12(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()~=Duel.GetTurnCount()
end
function c95482007.oop12(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
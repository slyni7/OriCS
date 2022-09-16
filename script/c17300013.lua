--
function c17300013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17300013+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c17300013.tar1)
	e1:SetOperation(c17300013.op1)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,17299987)
	e2:SetCost(c17300013.thcost)
	e2:SetTarget(c17300013.thtg)
	e2:SetOperation(c17300013.thop)
	c:RegisterEffect(e2)
end
function c17300013.tfil11(c,tp)
	return (Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.IsExistingMatchingCard(c17300013.tfil12,tp,LOCATION_DECK,0,1,nil,c:GetRightScale()))
		or (Duel.CheckLocation(tp,LOCATION_PZONE,1) and Duel.IsExistingMatchingCard(c17300013.tfil13,tp,LOCATION_DECK,0,1,nil,c:GetLeftScale()))
end
function c17300013.tfil12(c,s)
	return c:IsSetCard(0x2d1) and c:IsType(TYPE_PENDULUM) and c:GetLeftScale()~=s
end
function c17300013.tfil13(c,s)
	return c:IsSetCard(0x2d1) and c:IsType(TYPE_PENDULUM) and c:GetRightScale()~=s
end
function c17300013.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c17300013.tfil11,tp,LOCATION_PZONE,0,1,nil,tp)
	end
end
function c17300013.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c17300013.tfil11,tp,LOCATION_PZONE,0,nil,tp)
	if tc then
		local g=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		if Duel.CheckLocation(tp,LOCATION_PZONE,0) then
			g=Duel.SelectMatchingCard(tp,c17300013.tfil12,tp,LOCATION_DECK,0,1,1,nil,tc:GetRightScale())
		elseif Duel.CheckLocation(tp,LOCATION_PZONE,1) then
			g=Duel.SelectMatchingCard(tp,c17300013.tfil13,tp,LOCATION_DECK,0,1,1,nil,tc:GetLeftScale())
		end
		if g:GetCount()>0 then
			local pc=g:GetFirst()
			Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c17300013.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c17300013.thfilter(c)
	return c:IsSetCard(0x2d1) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))
end
function c17300013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17300013.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c17300013.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17300013.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

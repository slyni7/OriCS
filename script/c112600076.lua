--GLS(글라시스)-LYRITH
function c112600076.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xe8e),3,2,c112600076.ovfilter,aux.Stringid(112600076,0),2,c112600076.xyzop0)
	c:EnableReviveLimit()
	--xyz level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c112600076.xyztg)
	e2:SetOperation(c112600076.xyzop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112600076,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c112600076.cost)
	e3:SetTarget(c112600076.target)
	e3:SetOperation(c112600076.operation)
	c:RegisterEffect(e3)
end
function c112600076.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe8e) and not c:IsCode(112600076)
end
function c112600076.xyzop0(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,112600076)==0 end
	Duel.RegisterFlagEffect(tp,112600076,RESET_PHASE+PHASE_END,0,1)
	return true
end
function c112600076.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c112600076.filter(c)
	return c:IsRace(RACE_FIEND) and c:IsSummonableCard() and c:IsAbleToHand()
end
function c112600076.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112600076.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112600076.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c112600076.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c112600076.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c112600076.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c112600076.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c112600076.xyzfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c112600076.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c112600076.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_XYZ_LEVEL)
		e1:SetValue(c112600076.xyzlv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c112600076.xyzlv(e,c,rc)
	return c:GetRank()
end
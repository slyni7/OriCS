--천명의 관문
function c95480318.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480318+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95480318.target)
	e1:SetOperation(c95480318.activate)
	c:RegisterEffect(e1)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetTarget(c95480318.indtg)
	e4:SetValue(c95480318.indct)
	c:RegisterEffect(e4)
	--Trap activate in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd41))
	e2:SetCountLimit(1,95480382)
	c:RegisterEffect(e2)
end
function c95480318.filter(c)
	return c:IsSetCard(0xd41) and c:IsAbleToHand() and c:IsType(TYPE_TRAP)
end
function c95480318.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480318.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95480318.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95480318.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c95480318.indtg(e,c)
	return c:IsSetCard(0xd41) and c~=e:GetHandler()
end
function c95480318.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
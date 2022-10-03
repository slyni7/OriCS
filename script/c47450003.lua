--세계를 그리는 소녀

trig = false

function c47450003.initial_effect(c)
	--test
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47450003,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,47450003)
	e1:SetCondition(c47450003.condition)
	e1:SetCost(c47450003.cost)
	e1:SetOperation(c47450003.operation)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c47450003.condition1)
	e2:SetTarget(c47450003.target1)
	e2:SetOperation(c47450003.operation1)
	c:RegisterEffect(e2)

end
function c47450003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47450003.condition(e,tp,eg,ep,ev,re,r,rp)

	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.GetDecktopGroup(tp,ct)

	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c47450003.thfilter(c)
	return c:IsAbleToHand()
end

function c47450003.operation(e,tp,eg,ep,ev,re,r,rp)
	c=e:GetHandler()
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=Duel.SelectMatchingCard(tp,c47450003.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if hg:GetCount()>0 then
	Duel.SendtoHand(hg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,hg)
	trig = true
	end

end


function c47450003.condition1(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0 and trig
end
function c47450003.filter(c)
	return c:IsAbleToHand()
end
function c47450003.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47450003.filter,tp,LOCATION_DECK,0,1,nil) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimit(aux.FALSE)
end
function c47450003.operation1(e,tp,eg,ep,ev,re,r,rp)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)

	local g=Duel.SelectMatchingCard(tp,c47450003.filter,tp,LOCATION_DECK,0,1,1,nil)

	_replace_count=_replace_count+1

	if _replace_count<=_replace_max and g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
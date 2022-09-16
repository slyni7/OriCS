--¿ŒΩ∫≈Á ΩÍ≈∏
function c76859413.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76859413,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCost(c76859413.cost1)
	e1:SetTarget(c76859413.tg1)
	e1:SetOperation(c76859413.op1)
	c:RegisterEffect(e1)
	if not c76859413.global_check then
		c76859413.global_check=true
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_PHASE_START+PHASE_BATTLE_START)
		ge4:SetOperation(c76859413.gop4)
		Duel.RegisterEffect(ge4,0)
	end
end
function c76859413.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetFlagEffect(tp,76859413)==0
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,76859413,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c76859413.tfilter1(c)
	return c:IsSetCard(0x2c1) and c:IsAbleToHand() and not c:IsCode(76859413) and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function c76859413.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859413.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c76859413.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c76859413.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()<2 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,2,2,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
function c76859413.gop4(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(Duel.GetTurnPlayer(),76859413,RESET_PHASE+PHASE_END,0,1)
end
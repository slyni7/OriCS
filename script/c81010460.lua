function c81010460.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81010460+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81010460.tg)
	e1:SetOperation(c81010460.op)
	c:RegisterEffect(e1)
end

function c81010460.tgfilter(c)
	return c:IsSetCard(0xca1) and c:IsAbleToHand() and c:GetDefense()~=1000
	and c:IsType(TYPE_MONSTER)
end
function c81010460.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81010460.tgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81010460.opfilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xca1)
end
function c81010460.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81010460.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_PZONE,0,nil)>0
			and Duel.SelectYesNo(tp,aux.Stringid(81010460,0)) then
			local sg=Duel.SelectMatchingCard(tp,c81010460.opfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end


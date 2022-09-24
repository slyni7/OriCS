--サングラゼリッピの後押し
function c112400022.initial_effect(c)
	--e1(search)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112400022,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,112400022+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c112400022.target)
	e1:SetOperation(c112400022.operation)
	c:RegisterEffect(e1)
end
c112400022.listed_series={0x4ec1}
--e1(search)
function c112400022.thfilter1(c)
	return c:IsSetCard(0x4ec1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c112400022.thfilter2(c)
	return c:IsSetCard(0x4ec1) and bit.band(c:GetType(),0x1000001)==0x1000001 and c:IsAbleToHand()
end
function c112400022.exfilter(c)
	return bit.band(c:GetType(),TYPE_MONSTER+TYPE_PENDULUM)==TYPE_MONSTER+TYPE_PENDULUM and not c:IsForbidden()
end
function c112400022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112400022.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112400022.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c112400022.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if #g1>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g1)
		if Duel.IsExistingMatchingCard(c112400022.exfilter,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(c112400022.thfilter2,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(112400022,1)) then
				local sg=Duel.SelectMatchingCard(tp,c112400022.exfilter,tp,LOCATION_HAND,0,1,1,nil)
				if #sg>0 then
					Duel.SendtoExtraP(sg,tp,REASON_EFFECT)
					local g2=Duel.SelectMatchingCard(tp,c112400022.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
					if #g2>0 then
						Duel.SendtoHand(g2,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,g2)
					end
				end
		end
	end
end

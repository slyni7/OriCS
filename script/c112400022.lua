--サングラゼリッピの後押し
local s,id=c112400022,112400022
if GetID() then s,id=GetID() end
function s.initial_effect(c)
	--e1(search)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0x4ec1}
--e1(search)
function s.thfilter1(c)
	return c:IsSetCard(0x4ec1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thfilter2(c)
	return c:IsSetCard(0x4ec1) and bit.band(c:GetType(),0x1000001)==0x1000001 and c:IsAbleToHand()
end
function s.exfilter(c)
	return bit.band(c:GetType(),TYPE_MONSTER+TYPE_PENDULUM)==TYPE_MONSTER+TYPE_PENDULUM and not c:IsForbidden()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if #g1>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g1)
		if Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				local sg=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_HAND,0,1,1,nil)
				if #sg>0 then
					Duel.SendtoExtraP(sg,tp,REASON_EFFECT)
					local g2=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
					if #g2>0 then
						Duel.SendtoHand(g2,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,g2)
					end
				end
		end
	end
end

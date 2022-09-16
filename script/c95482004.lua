--청명의 비전술
function c95482004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95482004+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c95482004.cost)
	e1:SetTarget(c95482004.target)
	e1:SetOperation(c95482004.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(95482004,ACTIVITY_CHAIN,c95482004.chainfilter)
end
function c95482004.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0xd40) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY)
end
function c95482004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetCustomActivityCount(95482004,tp,ACTIVITY_CHAIN)<3 end
end
function c95482004.filter(c)
	return c:IsSetCard(0xd40) and c:IsType(TYPE_SPELL) and not c:IsCode(95482004) and c:IsAbleToHand()
end
function c95482004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95482004.filter,tp,LOCATION_DECK,0,1,nil) end
	local ct=Duel.GetCustomActivityCount(95482004,tp,ACTIVITY_CHAIN)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		ct=ct-1
	end
	local cat=CATEGORY_RECOVER
	if ct>=2 then
		cat=cat+CATEGORY_DRAW
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	e:SetCategory(cat)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95482004.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95482004.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local ct=Duel.GetCustomActivityCount(95482004,tp,ACTIVITY_CHAIN)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			ct=ct-1
		end
		if ct>=1 or ct>=2 then
			if ct>=1 and Duel.SelectYesNo(tp,aux.Stringid(95482004,1)) then
				Duel.BreakEffect()
				local rct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,TYPE_SPELL)
				Duel.Recover(tp,rct*200,REASON_EFFECT)
			end
			if ct>=2 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(95482004,2)) then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end


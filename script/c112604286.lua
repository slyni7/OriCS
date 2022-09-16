--ONESELF 카노네
local s,id=GetID()
function s.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e2:SetCost(s.cost1)
	e2:SetTarget(s.tar1)
	e2:SetOperation(s.op1)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
	e2:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(s.tar2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCountLimit(1,{id,2},EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(s.con3)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not c:IsPublic()
	end
	Duel.ConfirmCards(1-tp,c)
end
function s.tfil1(c)
	return c:IsFaceup() and c:IsSetCard(0xe75)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(s.tfil1,tp,LOCATION_MZONE,0,1,nil)
			and c:IsAbleToDeck()
	end
	Duel.SelectTarget(tp,s.tfil1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e2=MakeEff(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetValue(aux.imval1)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetValue(aux.tgoval)
		c:RegisterEffect(e3)
	end
end
function s.tfil2(c)
	return c:IsSetCard(0xe75) and not c:IsCode(id) and c:IsAbleToDeck() and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
		and (c:GetSequence()<5 or not c:IsLocation(LOCATION_MZONE))
		and (c:GetSequence()==5 or not c:IsLocation(LOCATION_SZONE))
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasableByEffect()
			and Duel.IsExistingMatchingCard(s.tfil2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Release(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.GetMatchingGroup(s.tfil2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,c)
		local g=aux.SelectUnselectGroup(sg,e,tp,1,#sg,aux.dncheck,1,tp,HINTMSG_TODECK)
		if #g>0 then
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.ConfirmDecktop(p,#g)
			local tg=Duel.GetDecktopGroup(tp,#g)
			if #tg>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sc=tg:FilterSelect(tp,Card.IsSetCard,1,1,nil,0xe75):GetFirst()
				if sc then
					if sc:IsAbleToHand() then
						Duel.SendtoHand(sc,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,sc)
						Duel.ShuffleHand(tp)
					else
						Duel.SendtoGrave(sc,REASON_RULE)
					end
				end
			end
		end
	end
end
function s.nfil3(c)
	return c:IsSetCard(0xe75) and c:IsFaceup()
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.nfil3,tp,LOCATION_MZONE,0,1,nil)
end
function s.thfilter(c)
	return c:IsSetCard(0xe75) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
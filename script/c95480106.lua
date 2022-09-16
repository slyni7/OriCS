--지천승자 에퀴녹스
function c95480106.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95480101,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,95480106)
	e1:SetTarget(c95480106.thtg)
	e1:SetOperation(c95480106.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c95480106.thcon)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c95480106.atkcon)
	e3:SetOperation(c95480106.atkop)
	c:RegisterEffect(e3)
end

function c95480106.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg1=Duel.GetLinkedGroup(tp,1,1)
	local lg2=Duel.GetLinkedGroup(1-tp,1,1)
	lg1:Merge(lg2)
	return lg1 and lg1:IsContains(e:GetHandler())
end
function c95480106.thfilter(c)
	return (c:IsSetCard(0xd5f) or c:IsSetCard(0xd55)) and c:IsType(TYPE_MONSTER) and not c:IsCode(95480106) and c:IsAbleToHand()
end
function c95480106.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c95480106.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(c95480106.thfilter,tp,LOCATION_DECK,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if ct>2 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,ct,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,dg,dg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,dg:GetCount(),tp,LOCATION_DECK)
end
function c95480106.thop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c95480106.thfilter,tp,LOCATION_DECK,0,nil)
	if ct==0 or g:GetCount()==0 then return end
	if ct>g:GetClassCount(Card.GetCode) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:Select(tp,1,1,nil)
	if ct==2 then
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=g:Select(tp,1,1,nil)
		g1:Merge(g2)
	end
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end

function c95480106.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO or r==REASON_LINK
end
function c95480106.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c95480106.lcon)
	e1:SetValue(1500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	rc:RegisterEffect(e2,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e3,true)
	end
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95480101,2))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ADD_SETCODE)
	e4:SetValue(0xd5f)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e4,true)
	local e5=e4:Clone()
	e5:SetValue(0xd55)
	rc:RegisterEffect(e5,true)
end
function c95480106.lcon(e)
	return e:GetHandler():IsLinkState()
end
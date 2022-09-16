--딸기의 위기!!
--카드군 번호: 0xc97
function c81261060.initial_effect(c)

	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--회피
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c81261060.tg2)
	c:RegisterEffect(e2)
	
	--드로우
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c81261060.tg3)
	e3:SetOperation(c81261060.op3)
	c:RegisterEffect(e3)
	
	--서치
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetCountLimit(1)
	e4:SetTarget(c81261060.tg4)
	e4:SetOperation(c81261060.op4)
	c:RegisterEffect(e4)
	if not c81261060.global_effect then
		c81261060.global_effect=true
		c81261060[0]={}
		c81261060[1]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c81261060.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(c81261060.gop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c81261060.gop3)
		Duel.RegisterEffect(ge3,0)
	end
end

--회피
function c81261060.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc97)
end
function c81261060.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsOnField() and c:IsFaceup() and c:IsReason(REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c81261060.cfil0,tp,0x10,0,2,nil)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(81261060,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c81261060.cfil0,tp,0x10,0,2,2,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		return true
	else 
		return false
	end
end

--드로우
function c81261060.tfil0(c)
	return c:IsFaceup() and c:IsSetCard(0xc97)
end
function c81261060.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x20) and chkc:IsControler(tp) and c81261060.tfil0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81261060.tfil0,tp,0x20,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c81261060.tfil0,tp,0x20,0,1,4,nil)
	local d=math.floor(g:GetCount()/2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,d)
end
function c81261060.op3(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=tg:Filter(Card.IsRelateToEffect,nil,e)
	if tc then
		Duel.SendtoGrave(tc,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,2,nil,0x10) then
			local ct=g:FilterCount(Card.IsLocation,nil,0x10)
			local d=math.floor((ct)/2)
			Duel.Draw(tp,d,REASON_EFFECT)
		end
	end
end

--서치
function c81261060.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return c81261060[tp][Duel.GetTurnCount()]>0
	end
end
function c81261060.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	e1:SetOperation(c81261060.oop41)
	Duel.RegisterEffect(e1,tp)
end
function c81261060.oofil41(c)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and c:IsSetCard(0xc97) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function c81261060.oop41(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,81261060)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81261060.oofil41,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,c81261060[tp][Duel.GetTurnCount()-1],nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c81261060.gop1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnCount()
	local rc=re:GetHandler()
	if rc:IsSetCard(0xc97) and rc:IsType(TYPE_QUICKPLAY) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c81261060[rp][ct]=c81261060[rp][ct]+1
	end
end
function c81261060.gop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnCount()
	local rc=re:GetHandler()
	if rc:IsSetCard(0xc97) and rc:IsType(TYPE_QUICKPLAY) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		if c81261060[rp][ct]>0 then
			c81261060[rp][ct]=c81261060[rp][ct]-1
		end
	end
end
function c81261060.gop3(e,tp,eg,ep,ev,re,r,rp)
	c81261060[0][Duel.GetTurnCount()]=0
	c81261060[1][Duel.GetTurnCount()]=0
end
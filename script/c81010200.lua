--MMJ RuisuiRei

function c81010200.initial_effect(c)
	c:EnableReviveLimit()
	
	--swap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81010200,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1)
	e1:SetCost(c81010200.swaco)
	e1:SetTarget(c81010200.swatg)
	e1:SetOperation(c81010200.swaop)
	c:RegisterEffect(e1)
	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010200,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,81010200)
	e2:SetTarget(c81010200.thtg)
	e2:SetOperation(c81010200.thop)
	c:RegisterEffect(e2)
	
end

--swap
function c81010200.swacofilter(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsReleasable()
end
function c81010200.swaco(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_MZONE+LOCATION_HAND
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81010200.swacofilter,tp,loc,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81010200.swacofilter,tp,loc,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function c81010200.swatgfilter(c)
	return c:IsFaceup()
end
function c81010200.swatg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c81010200.swatgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81010200.swatgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81010200.swatgfilter,tp,0,LOCATION_MZONE,1,1,nil)
end

function c81010200.swaop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(0)
		tc:RegisterEffect(e2)
	end
end


--search
function c81010200.thtgfilter(c)
	return c:IsSetCard(0xca1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c81010200.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010200.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81010200.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81010200.thtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--노을빛

function c81010400.initial_effect(c)
	
	--summon method
	
	c:EnableReviveLimit()

	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81010400,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,81010400)
	e3:SetCondition(c81010400.hdcn)
	e3:SetTarget(c81010400.hdtg)
	e3:SetOperation(c81010400.hdop)
	c:RegisterEffect(e3)
	
	--return to hand + damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81010400,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,81010401)
	e4:SetCost(c81010400.ddco)
	e4:SetTarget(c81010400.ddtg)
	e4:SetOperation(c81010400.ddop)
	c:RegisterEffect(e4)
	
end

--summon method
function c81010400.splm(e,se,sp,st)
	return se:GetHandler():IsType(TYPE_RITUAL)
end

--handes
function c81010400.hdcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end

function c81010400.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil)
			end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end

function c81010400.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end

--return to hand + damage
function c81010400.ddcofilter(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost()
	   and c:IsSetCard(0xca1)
end
function c81010400.ddco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81010400.ddcofilter,tp,0x0c,0,1,c)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c81010400.ddcofilter,tp,0x0c,0,1,1,c)
	Duel.SendtoHand(g,nil,REASON_COST)
	Duel.ConfirmCards(1-tp,g)
end
function c81010400.ddtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end

function c81010400.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.Damage(1-tp,500,REASON_EFFECT)
		if tc and c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end

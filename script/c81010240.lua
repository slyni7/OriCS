--ahyakuro: 1

function c81010240.initial_effect(c)
	
	--send to Deck + ATK/DEF update
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81010240,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81010240)
	e1:SetCost(c81010240.adco)
	e1:SetOperation(c81010240.adop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81010240,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,81010241)
	e4:SetCondition(c81010240.thcn)
	e4:SetCost(c81010240.thco)
	e4:SetTarget(c81010240.thtg)
	e4:SetOperation(c81010240.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e5)
	
end

--send to Deck + ATK/DEF update
function c81010240.adcofilter(c)
	return c:IsSetCard(0xca1) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c81010240.adco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010240.adcofilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81010240.adcofilter,tp,LOCATION_DECK,0,1,1,nil)
	local lv=g:GetFirst():GetLevel()
	e:SetLabel(lv)
	Duel.SendtoGrave(g,REASON_COST)
end

function c81010240.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local lv=e:GetLabel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(lv*100)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end

--search
function c81010240.thcnfilter(c,tp)
	return c:IsSetCard(0xca1)
		and c:GetPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_GRAVE)
		and not c:IsType(TYPE_TOKEN)
end
function c81010240.thcn(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81010240.thcnfilter,1,nil,tp)
end

function c81010240.thco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c81010240.thtgfilter(c)
	return c:IsSetCard(0xca1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
	and c:IsLevelAbove(4) and not c:IsCode(81010240)
end
function c81010240.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010240.thtgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81010240.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81010240.thtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

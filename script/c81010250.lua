--ahyakuro: 2

function c81010250.initial_effect(c)
	
	--return to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81010250,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81010250)
	e1:SetTarget(c81010250.rhtg)
	e1:SetOperation(c81010250.rhop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	
	--cannot sspm from exdeck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81010250,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,81010251)
	e4:SetCondition(c81010250.shcn)
	e4:SetCost(c81010250.shco)
	e4:SetTarget(c81010250.shtg)
	e4:SetOperation(c81010250.shop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e5)
	
end

--return to hand
function c81010250.rhtgfilter(c)
	return c:IsSetCard(0xca1) and c:IsAbleToHand() and not c:IsCode(81010250)
end
function c81010250.rhtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81010250.rhtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81010250.rhtgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81010250.rhtgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c81010250.rhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			if tc:IsType(TYPE_MONSTER)
			and not (tc:IsType(TYPE_LINK) or tc:IsType(TYPE_FUSION) or tc:IsType(TYPE_RITUAL) or tc:IsType(TYPE_SYNCHRO) or tc:IsType(TYPE_XYZ))
			and Duel.SelectYesNo(tp,aux.Stringid(81010250,1)) then
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
					Duel.ShuffleHand(tp)
		end
	end
end

--destroy
function c81010250.shcnfilter(c,tp)
	return c:IsSetCard(0xca1)
		and c:GetPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_GRAVE)
		and not c:IsType(TYPE_TOKEN)
end
function c81010250.shcn(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81010250.shcnfilter,1,nil,tp)
end

function c81010250.shco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c81010250.shtgfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xca1) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81010250.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81010250.shtgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81010250.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81010250.shtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

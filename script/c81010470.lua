function c81010470.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81010470,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81010470)
	e1:SetTarget(c81010470.tg)
	e1:SetOperation(c81010470.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,81010471)
	e2:SetCondition(c81010470.vcn)
	e2:SetTarget(c81010470.vtg)
	e2:SetOperation(c81010470.vop)
	c:RegisterEffect(e2)
end

--
function c81010470.cfilter(c)
	return c:IsSetCard(0xca1) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
	and ( c:IsFaceup() or c:IsLocation(LOCATION_HAND) ) 
end
function c81010470.mzfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c81010470.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=Duel.GetMatchingGroup(c81010470.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c)
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and sg:GetCount()>=1 and (ft>0 or sg:IsExists(c81010470.mzfilter,1,nil))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c81010470.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=Duel.GetMatchingGroup(c81010470.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c)
	local g=nil
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:FilterSelect(tp,c81010470.mzfilter,1,1,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=sg:Select(tp,1,1,nil)
	end
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c81010470.vcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c81010470.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xca1) and c:IsAbleToHand()
	and not c:IsAttribute(ATTRIBUTE_WIND)
end
function c81010470.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81010470.filter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81010470.vop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81010470.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

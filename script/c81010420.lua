--mmj 
function c81010420.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81010420,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,81010420)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c81010420.spcn)
	e1:SetCost(c81010420.spco)
	e1:SetTarget(c81010420.sptg)
	e1:SetOperation(c81010420.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e2)
	
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81010420,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,81010421)
	e4:SetCondition(c81010420.tscn)
	e4:SetCost(c81010420.tsco)
	e4:SetTarget(c81010420.tstg)
	e4:SetOperation(c81010420.tsop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e5)
	
end

--special summon
function c81010420.spcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) 
	and re:GetHandler():IsSetCard(0xca1)
end

function c81010420.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
			end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function c81010420.sptgfilter(c,e,tp)
	return c:IsSetCard(0xca1) and c:IsDefense(1000)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81010420.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c81010420.sptgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

function c81010420.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81010420.sptgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

--special summon (cost)
function c81010420.tscnfilter(c,tp)
	return c:IsSetCard(0xca1)
	and c:GetPreviousControler(tp)
	and c:IsPreviousLocation(LOCATION_GRAVE)
	and not c:IsType(TYPE_TOKEN)
end
function c81010420.tscn(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81010420.tscnfilter,1,nil,tp)
end

function c81010420.tsco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		e:GetHandler():IsAbleToRemoveAsCost()
	end
	Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_COST)
end

function c81010420.tstgfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and c:IsSetCard(0xca1) and c:IsType(TYPE_MONSTER)
	and not c:GetCode()~=e:GetHandler()
end
function c81010420.tstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
		chkc:IsLocation(LOCATION_REMOVED)
	and chkc:IsControler(tp)
	and c81010420.tstgfilter(chkc,e,tp)
	end
	if chk==0 then return
		Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingTarget(c81010420.tstgfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81010420.tstgfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c81010420.tsop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end



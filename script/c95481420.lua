--명도의 인도자 부알
function c95481420.initial_effect(c)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9342162,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,95481420)
	e2:SetCondition(c95481420.sscon)
	e2:SetTarget(c95481420.sstg)
	e2:SetOperation(c95481420.ssop)
	c:RegisterEffect(e2)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(35952884,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_DECKDES)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,95481480)
	e4:SetCondition(c95481420.sumcon)
	e4:SetTarget(c95481420.sumtg)
	e4:SetOperation(c95481420.sumop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
end
function c95481420.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c95481420.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c95481420.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c95481420.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c95481420.ctfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c95481420.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c95481420.ctfilter,tp,0,LOCATION_MZONE,nil)
	local ct=g:GetCount()
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c95481420.sumop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c95481420.ctfilter,tp,0,LOCATION_MZONE,nil)
	local ct=g:GetCount()
	Duel.DiscardDeck(tp,ct,REASON_EFFECT)
end

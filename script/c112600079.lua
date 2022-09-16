--GLS(글라시스)-MiLK(밀크)
function c112600079.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,c112600079.ovfilter,aux.Stringid(112600079,0))
	c:EnableReviveLimit()
	--maintain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c112600079.mtcon)
	e1:SetOperation(c112600079.mtop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c112600079.efilter)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(112600079,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c112600079.cost)
	e3:SetTarget(c112600079.sptg)
	e3:SetOperation(c112600079.spop)
	c:RegisterEffect(e3)
	--grave sp
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(112600079,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c112600079.spcon2)
	e4:SetTarget(c112600079.sptg2)
	e4:SetOperation(c112600079.spop2)
	c:RegisterEffect(e4)
	--atk/def
	local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c112600079.xyzcon)
	e5:SetValue(500)
    c:RegisterEffect(e5)
	local e6=e5:Clone()
    e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
end
function c112600079.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe8e) and not c:IsCode(112600079) and c:IsType(TYPE_XYZ) and c:IsRank(3)
end
function c112600079.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c112600079.mtop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function c112600079.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c112600079.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c112600079.spfilter(c,e,tp)
	return c:IsSetCard(0xe8e) or c:IsSetCard(0xe88) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112600079.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c112600079.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c112600079.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112600079.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c112600079.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c112600079.spfilter2(c,e,tp)
	return c:IsLevelBelow(5) and c:IsSetCard(0xe8e) or c:IsSetCard(0xe88) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112600079.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c112600079.spfilter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c112600079.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c112600079.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c112600079.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c112600079.xyzcon(e)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xe88)
end
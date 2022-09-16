--알피스트 바르그
function c95482118.initial_effect(c)
	--spsummon (DM)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71696014,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,95482118)
	e1:SetCost(c95482118.cost)
	e1:SetTarget(c95482118.target1)
	e1:SetOperation(c95482118.operation1)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c95482118.reptg)
	e2:SetValue(c95482118.repval)
	e2:SetOperation(c95482118.repop)
	c:RegisterEffect(e2)
end
function c95482118.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c95482118.filter(c,e,tp)
	return c:IsCode(95482101) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95482118.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c95482118.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c95482118.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95482118.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c95482118.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xd5a) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
end
function c95482118.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and aux.exccon(e) and eg:IsExists(c95482118.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c95482118.repval(e,c)
	return c95482118.repfilter(c,e:GetHandlerPlayer())
end
function c95482118.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end

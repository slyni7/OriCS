--인스톨 이오타
function c76859419.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCost(c76859419.cost1)
	e1:SetTarget(c76859419.tg1)
	e1:SetOperation(c76859419.op1)
	c:RegisterEffect(e1)
end
function c76859419.cfilter1(c)
	return c:IsSetCard(0x2c1) and c:IsAbleToRemoveAsCost()
end
function c76859419.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c76859419.cfilter1,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c76859419.cfilter1,tp,LOCATION_HAND,0,1,1,nil)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c76859419.tfilter1(c,e,tp,ec)
	return c:IsSetCard(0x2c1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,ec,c)>0
end
function c76859419.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859419.tfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c76859419.op1(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetLocationCountFromEx and Duel.GetLocationCountFromEx(tp)<1)
		or (not Duel.GetLocationCountFromEx and Duel.GetLocationCount(tp,LOCATION_MZONE)<1) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c76859419.tfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		tc:CompleteProcedure()
	end
end
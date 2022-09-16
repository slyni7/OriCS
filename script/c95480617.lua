--이레귤러: 패러렐 인터섹트
function c95480617.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,95480617+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95480617.target)
	e1:SetOperation(c95480617.operation)
	c:RegisterEffect(e1)
end
function c95480617.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xd57) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c95480617.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c95480617.spfilter(c,e,tp,code)
	return c:IsSetCard(0xd57) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480617.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c95480617.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c95480617.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c95480617.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c95480617.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95480617.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.Remove(tc,nil,REASON_EFFECT)
		end
	end
end
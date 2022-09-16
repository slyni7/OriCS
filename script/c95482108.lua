--ティマイオスの眼
function c95482108.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95482108+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95482108.target)
	e1:SetOperation(c95482108.activate)
	c:RegisterEffect(e1)
end
function c95482108.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xd5a) and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c95482108.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetCode())
end
function c95482108.spfilter(c,e,tp,tc,code)
   if not c:IsAttribute(ATTRIBUTE_EARTH) then
	  return false
   end
	return aux.IsMaterialListCode(c,code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c95482108.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c95482108.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c95482108.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c95482108.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c95482108.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeFusionMaterial() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c95482108.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetCode())
		local sc=sg:GetFirst()
		if sc then
			sc:SetMaterial(Group.FromCards(tc))
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
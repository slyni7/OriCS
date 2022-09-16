--샤를로트-달레트
function c84320031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c84320031.target1)
	e1:SetOperation(c84320031.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84320031,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c84320031.target2)
	e2:SetOperation(c84320031.operation)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
end
function c84320031.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(84320031)==0 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c84320031.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	e:GetHandler():RegisterFlagEffect(84320031,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SelectYesNo(tp,94)
end
function c84320031.filter(c,e,tp)
	return c:IsSetCard(0x7a1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84320031.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(84320031)==0 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c84320031.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	e:GetHandler():RegisterFlagEffect(84320031,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND,e,tp)
end
function c84320031.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(84320031)==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c84320031.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,e,tp)
	end
end




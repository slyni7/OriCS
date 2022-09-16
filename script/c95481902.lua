--인챈트릭스 시프
function c95481902.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetCountLimit(1,95481902)
	e1:SetTarget(c95481902.tar1)
	e1:SetOperation(c95481902.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetCountLimit(1,95481902)
	e2:SetCost(c95481902.cost2)
	e2:SetTarget(c95481902.tar2)
	e2:SetOperation(c95481902.op2)
	c:RegisterEffect(e2)
end
function c95481902.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,1-tp,LOCATION_HAND)
end
function c95481902.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:RandomSelect(tp,1)
	local tc=sg:GetFirst()
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and
		Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
function c95481902.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and
			c:IsAbleToRemoveAsCost()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c95481902.tgfil1(c)
	return not c:IsPublic() or c:IsType(TYPE_MONSTER)
end
function c95481902.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if chk==0 then return g and g:IsExists(c95481902.tgfil1,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,1-tp,LOCATION_HAND)
end
function c95481902.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
	if #g<1 then
		return
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:FilterSelect(1-tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false)
	local tc=sg:GetFirst()
	if tc then
		Duel.SpecialSummonStep(tc,0,1-tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECKBOT)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
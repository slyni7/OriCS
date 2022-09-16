--명성제룡 에퀴녹스
function c95480109.initial_effect(c)
	--special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5560911,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,95480109)
	e1:SetCost(c95480109.cost)
	e1:SetTarget(c95480109.target)
	e1:SetOperation(c95480109.operation)
	c:RegisterEffect(e1)
end
function c95480109.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c95480109.filter(c)
	return c:IsFaceup() and c:IsLinkState() and c:IsSetCard(0xd5f) and c:IsLevelAbove(1) and not (c:IsLevel(10) and c:IsRace(RACE_WYRM) and c:GetAttack()==0 and c:GetDefense()==0)
end
function c95480109.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c95480109.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c95480109.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c95480109.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95480109.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			if tc:IsRelateToEffect(e) and tc:IsFaceup() then
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
				tc:RegisterEffect(e2)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_CHANGE_RACE)
				e3:SetValue(RACE_WYRM)
				tc:RegisterEffect(e3)
				local e4=Effect.CreateEffect(tc)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e4:SetCode(EFFECT_CHANGE_LEVEL)
				e4:SetValue(10)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e4)
			end
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e5:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e5:SetValue(LOCATION_DECKBOT)
			c:RegisterEffect(e5)
		end
		Duel.SpecialSummonComplete()
	end
end

--천승자에 주어진 숙명
function c95481523.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,95481523+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95481523.target)
	e1:SetOperation(c95481523.operation)
	c:RegisterEffect(e1)
end
function c95481523.filter(c)
	return ((c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0xd55))
		and not c:IsCode(95481523) and c:IsAbleToDeck()
end
function c95481523.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(c95481523.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c95481523.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c95481523.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)>0 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
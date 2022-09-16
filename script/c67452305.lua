--사이플루이드 카린
function c67452305.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PAY_LPCOST)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c67452305.con1)
	e1:SetTarget(c67452305.tar1)
	e1:SetOperation(c67452305.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e2:SetCountLimit(1)
	e2:SetDescription(aux.Stringid(67452305,0))
	e2:SetCost(c67452305.cost2)
	e2:SetTarget(c67452305.tar2)
	e2:SetOperation(c67452305.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1)
	e3:SetDescription(aux.Stringid(67452305,1))
	e3:SetCondition(c67452305.con3)
	e3:SetCost(c67452305.cost3)
	e3:SetTarget(c67452305.tar3)
	e3:SetOperation(c67452305.op3)
	c:RegisterEffect(e3)
end
function c67452305.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and Duel.GetLP(tp)<=c:GetAttack()
end
function c67452305.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67452305.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c67452305.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,700)
	else
		Duel.PayLPCost(tp,700)
	end
end
function c67452305.tfil2(c)
	return c:IsSetCard(0x2db)
end
function c67452305.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c67452305.tfil2,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c67452305.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local dg=Duel.SelectMatchingCard(tp,c67452305.tfil2,tp,LOCATION_HAND,0,1,1,nil)
	if dg:GetCount()>0 then
		Duel.SendtoGrave(dg,REASON_DISCARD+REASON_EFFECT)
	end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c67452305.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLP(tp)<=c:GetAttack()
end
function c67452305.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function c67452305.tfil3(c,e,tp)
	return c:IsSetCard(0x2db) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and not c:IsCode(67452305)
end
function c67452305.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return ckhc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c67452305.tfil3(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetMZoneCount(tp,c,tp)>0
			and Duel.IsExistingTarget(c67452305.tfil3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c67452305.tfil3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c67452305.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
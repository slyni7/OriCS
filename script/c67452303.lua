--사이플루이드 주니엘
function c67452303.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PAY_LPCOST)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c67452303.con1)
	e1:SetTarget(c67452303.tar1)
	e1:SetOperation(c67452303.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetCountLimit(1)
	e2:SetDescription(aux.Stringid(67452303,0))
	e2:SetCost(c67452303.cost2)
	e2:SetTarget(c67452303.tar2)
	e2:SetOperation(c67452303.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCountLimit(1)
	e3:SetDescription(aux.Stringid(67452303,1))
	e3:SetCondition(c67452303.con3)
	e3:SetCost(c67452303.cost3)
	e3:SetTarget(c67452303.tar3)
	e3:SetOperation(c67452303.op3)
	c:RegisterEffect(e3)
end
function c67452303.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and Duel.GetLP(tp)<=c:GetAttack()
end
function c67452303.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67452303.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c67452303.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,700)
	else
		Duel.PayLPCost(tp,700)
	end
end
function c67452303.tfil2(c)
	return c:IsSetCard(0x2db) and c:IsAbleToRemove() and not c:IsCode(67452303)
end
function c67452303.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c67452303.tfil2,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c67452303.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c67452303.tfil2,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then
		return
	end
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c67452303.ocon21)
	e1:SetOperation(c67452303.oop21)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetLabel(0)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY)
	end
	tc:RegisterEffect(e1)
end
function c67452303.ocon21(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()~=Duel.GetTurnCount()
end
function c67452303.oop21(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,c)
end
function c67452303.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLP(tp)<=c:GetAttack()
end
function c67452303.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c67452303.cfil31(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2db) and c:IsAbleToRemoveAsCost() and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil)
end
function c67452303.cfil32(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x2db) and c:IsAbleToRemoveAsCost() and Duel.IsExistingTarget(c67452303.tfil32,tp,0,LOCATION_ONFIELD,1,nil)
end
function c67452303.tfil32(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c67452303.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		if e:GetLabel()~=100 then
			return false
		end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c67452303.cfil31,tp,LOCATION_GRAVE,0,1,nil,tp)
			or Duel.IsExistingMatchingCard(c67452303.cfil32,tp,LOCATION_GRAVE,0,1,nil,tp)
	end
	local opt=0
	if Duel.IsExistingMatchingCard(c67452303.cfil31,tp,LOCATION_GRAVE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c67452303.cfil32,tp,LOCATION_GRAVE,0,1,nil,tp) then
		opt=Duel.SelectOption(tp,aux.Stringid(67452303,2),aux.Stringid(67452303,3))
	elseif Duel.IsExistingMatchingCard(c67452303.cfil31,tp,LOCATION_GRAVE,0,1,nil,tp) then
		opt=0
	else
		opt=1
	end
	if opt==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local cg=Duel.SelectMatchingCard(tp,c67452303.cfil31,tp,LOCATION_GRAVE,0,1,1,nil,tp)
		Duel.Remove(cg,POS_FACEUP,REASON_COST)
		local tg=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local cg=Duel.SelectMatchingCard(tp,c67452303.cfil32,tp,LOCATION_GRAVE,0,1,1,nil,tp)
		Duel.Remove(cg,POS_FACEUP,REASON_COST)
		local tg=Duel.SelectTarget(tp,c67452303.tfil32,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
	end
end
function c67452303.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
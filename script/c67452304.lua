--사이플루이드 미카
function c67452304.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PAY_LPCOST)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c67452304.con1)
	e1:SetTarget(c67452304.tar1)
	e1:SetOperation(c67452304.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCountLimit(1)
	e2:SetDescription(aux.Stringid(67452304,0))
	e2:SetCost(c67452304.cost2)
	e2:SetTarget(c67452304.tar2)
	e2:SetOperation(c67452304.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetCountLimit(1)
	e3:SetDescription(aux.Stringid(67452304,1))
	e3:SetCondition(c67452304.con3)
	e3:SetCost(c67452304.cost3)
	e3:SetTarget(c67452304.tar3)
	e3:SetOperation(c67452304.op3)
	c:RegisterEffect(e3)
end
function c67452304.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and Duel.GetLP(tp)<=c:GetAttack()
end
function c67452304.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67452304.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c67452304.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,700)
	else
		Duel.PayLPCost(tp,700)
	end
end
function c67452304.tfil2(c)
	return c:IsSetCard(0x2db) and c:IsAbleToHand() and not c:IsCode(67452304)
end
function c67452304.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
			and Duel.IsExistingMatchingCard(c67452304.tfil2,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67452304.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if dg:GetCount()>0 then
		Duel.SendtoGrave(dg,REASON_DISCARD+REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ag=Duel.SelectMatchingCard(tp,c67452304.tfil2,tp,LOCATION_DECK,0,1,1,nil)
	if ag:GetCount()>0 then
		Duel.SendtoHand(ag,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,ag)
	end
end
function c67452304.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLP(tp)<=c:GetAttack()
end
function c67452304.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c67452304.cfil31(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2db) and c:IsDiscardable() and Duel.IsExistingTarget(c67452304.tfil31,tp,0,LOCATION_MZONE,1,nil)
end
function c67452304.cfil32(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x2db) and c:IsDiscardable() and Duel.IsExistingTarget(c67452304.tfil32,tp,0,LOCATION_ONFIELD,1,nil)
end
function c67452304.tfil31(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c67452304.tfil32(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and not c:IsDisabled()
end
function c67452304.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		if e:GetLabel()~=100 then
			return false
		end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c67452304.cfil31,tp,LOCATION_HAND,0,1,nil,tp)
			or Duel.IsExistingMatchingCard(c67452304.cfil32,tp,LOCATION_HAND,0,1,nil,tp)
	end
	local opt=0
	if Duel.IsExistingMatchingCard(c67452304.cfil31,tp,LOCATION_HAND,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c67452304.cfil32,tp,LOCATION_HAND,0,1,nil,tp) then
		opt=Duel.SelectOption(tp,aux.Stringid(67452304,2),aux.Stringid(67452304,3))
	elseif Duel.IsExistingMatchingCard(c67452304.cfil31,tp,LOCATION_HAND,0,1,nil,tp) then
		opt=0
	else
		opt=1
	end
	if opt==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local cg=Duel.SelectMatchingCard(tp,c67452304.cfil31,tp,LOCATION_HAND,0,1,1,nil,tp)
		Duel.SendtoGrave(cg,REASON_COST+REASON_DISCARD)
		local tg=Duel.SelectTarget(tp,c67452304.tfil31,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,tg,1,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local cg=Duel.SelectMatchingCard(tp,c67452304.cfil32,tp,LOCATION_HAND,0,1,1,nil,tp)
		Duel.SendtoGrave(cg,REASON_COST+REASON_DISCARD)
		local tg=Duel.SelectTarget(tp,c67452304.tfil32,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,tg,1,0,0)
	end
end
function c67452304.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
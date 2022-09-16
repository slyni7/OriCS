--사이플루이드 카스티아
function c67452301.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PAY_LPCOST)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c67452301.con1)
	e1:SetTarget(c67452301.tar1)
	e1:SetOperation(c67452301.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCountLimit(1)
	e2:SetDescription(aux.Stringid(67452301,0))
	e2:SetCost(c67452301.cost2)
	e2:SetTarget(c67452301.tar2)
	e2:SetOperation(c67452301.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetDescription(aux.Stringid(67452301,1))
	e3:SetCondition(c67452301.con3)
	e3:SetTarget(c67452301.tar3)
	e3:SetOperation(c67452301.op3)
	c:RegisterEffect(e3)
end
function c67452301.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and Duel.GetLP(tp)<=c:GetAttack()
end
function c67452301.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67452301.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c67452301.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,700)
	else
		Duel.PayLPCost(tp,700)
	end
end
function c67452301.tfil2(c)
	return c:IsSetCard(0x2db) and c:IsFaceup()
end
function c67452301.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c67452301.tfil2,tp,LOCATION_MZONE,0,1,nil)
	end
end
function c67452301.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c67452301.tfil2,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(700)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c67452301.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLP(tp)<=c:GetAttack()
end
function c67452301.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsOnField() and c67452301.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c67452301.tfil2,tp,LOCATION_ONFIELD,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c67452301.tfil2,tp,LOCATION_ONFIELD,0,1,1,nil)
	local opt=Duel.SelectOption(tp,aux.Stringid(67452301,2),aux.Stringid(67452301,3))
	e:SetLabel(opt)
end
function c67452301.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if e:GetLabel()==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCountLimit(1)
			e1:SetValue(c67452301.oval31)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		else
			tc:RegisterFlagEffect(67452301,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetCountLimit(1)
			e1:SetCondition(c67452301.ocon31)
			e1:SetOperation(c67452301.oop31)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c67452301.oval31(e,re,r,rp)
	return r==RESAON_BATTLE or (r==REASON_EFFECT and rp~=e:GetHandlerPlayer())
end
function c67452301.ocon31(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(67452301)==0 or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return false
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(tc) and rp~=tp
end
function c67452301.oop31(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
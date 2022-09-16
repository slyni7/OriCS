--메카쿠시단 단원 08 아마미야 히비야
function c95480208.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd4c),4,2)
	c:EnableReviveLimit()
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,95480208)
	e1:SetCondition(c95480208.con1)
	e1:SetCost(c95480208.cost)
	e1:SetTarget(c95480208.tg1)
	e1:SetOperation(c95480208.op1)
	c:RegisterEffect(e1)
	--double
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95480208)
	e2:SetCondition(c95480208.con2)
	e2:SetCost(c95480208.cost)
	e2:SetTarget(c95480208.tg2)
	e2:SetOperation(c95480208.op2)
	c:RegisterEffect(e2)
end

function c95480208.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c95480208.con1(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and (re:IsActiveType(TYPE_MONSTER)
		or (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)))
end
function c95480208.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c95480208.op1(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c95480208.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==1-tp and (aux.disfilter1(c) or c:GetAttack()>0)
end
function c95480208.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95480208.cfilter,1,nil,tp)
end
function c95480208.disfilter(c,g)
	return g:IsContains(c)
end
function c95480208.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c95480208.cfilter,nil,tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c95480208.disfilter(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(c95480208.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,c95480208.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	end
end
function c95480208.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(95480208,RESET_EVENT+RESET_TURN_SET+RESET_OVERLAY+RESET_MSCHANGE+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(95480208,1))
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetLabel(fid)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetOperation(c95480208.damop)
		Duel.RegisterEffect(e3,tp)
	end
end
function c95480208.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not eg:IsContains(tc) then return end
	if tc:GetFlagEffectLabel(95480208)~=e:GetLabel() then
		e:Reset()
		return
	end
	Duel.Hint(HINT_CARD,0,95480208)
	Duel.Damage(tc:GetPreviousControler(),tc:GetBaseAttack(),REASON_EFFECT)
	tc:ResetFlagEffect(95480208)
	e:Reset()
end

--煉獄の死徒
function c95480225.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c95480225.target)
	e1:SetOperation(c95480225.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95480225,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c95480225.reptg)
	e2:SetValue(c95480225.repval)
	c:RegisterEffect(e2)
end
c95480225.Mekakuci_list=true
function c95480225.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd4b)
end
function c95480225.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c95480225.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95480225.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c95480225.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c95480225.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c95480225.efilter)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
	end
end
function c95480225.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c95480225.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0xd4b) and c:IsReason(REASON_EFFECT)
end
function c95480225.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c95480225.repfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(95480225,0)) then
		local g=eg:Filter(c95480225.repfilter,nil,tp)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
function c95480225.repval(e,c)
	return c==e:GetLabelObject()
end
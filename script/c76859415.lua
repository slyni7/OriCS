--인스톨 시그마
function c76859415.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76859415,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCost(c76859415.cost1)
	e1:SetTarget(c76859415.tg1)
	e1:SetOperation(c76859415.op1)
	c:RegisterEffect(e1)
	if not c76859415.global_check then
		c76859415.global_check=true
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_PHASE_START+PHASE_BATTLE_START)
		ge4:SetOperation(c76859415.gop4)
		Duel.RegisterEffect(ge4,0)
	end
end
function c76859415.cfilter1(c)
	return c:IsSetCard(0x2c1) and c:IsAbleToRemoveAsCost() and not c:IsCode(76859415)
end
function c76859415.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetFlagEffect(tp,76859415)==0 and Duel.IsExistingMatchingCard(c76859415.cfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,3,nil)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,76859415,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c76859415.cfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c76859415.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE)
end
function c76859415.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		local atk=g:GetFirst():GetAttack()
		local def=g:GetFirst():GetDefense()
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT) then
			local rv=0
			if atk>def then
				rv=atk
			else
				rv=def
			end
			if rv<0 then
				rv=0
			end
			Duel.Recover(tp,rv/2,REASON_EFFECT)
		end
	end
end
function c76859415.gop4(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(Duel.GetTurnPlayer(),76859415,RESET_PHASE+PHASE_END,0,1)
end
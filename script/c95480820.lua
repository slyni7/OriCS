--클라디스 메이든 다크 저지먼트
function c95480820.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd52),8,2,nil,nil,99)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21521304,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c95480820.viccon)
	e1:SetOperation(c95480820.vicop)
	c:RegisterEffect(e1)
	--turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,95480820)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c95480820.cost)
	e2:SetTarget(c95480820.target)
	e2:SetOperation(c95480820.operation)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetCountLimit(1,95480880)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c95480820.reptg)
	c:RegisterEffect(e3)
end
function c95480820.viccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c95480820.vicop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	Duel.SetLP(tp,Duel.GetLP(tp)-ct*500)
	if Duel.GetFlagEffect(tp,95480820)~=0 then return end
	Duel.RegisterFlagEffect(tp,95480820,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,10)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCondition(c95480820.checkcon)
	e1:SetOperation(c95480820.checkop)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,10)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(1082946,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,10)
	c95480820[c]=e1
end
function c95480820.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c95480820.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,95480820)
	c:SetHint(CHINT_TURN,ct)
	Duel.RegisterFlagEffect(tp,95480820,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,11-ct)
	if ct==10 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=1 then
		Duel.Win(tp,0x11)
		c:ResetFlagEffect(1082946)
	end
end

function c95480820.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c95480820.filter(c,e)
	return c:GetFlagEffect(1082946)~=0 and c==e:GetHandler()
end
function c95480820.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480820.filter,tp,0x3f,0x3f,1,nil,e) end
end
function c95480820.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c95480820.filter,tp,0x3f,0x3f,1,1,nil,e)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
end
function c95480820.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end

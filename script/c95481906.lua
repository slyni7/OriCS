--인챈트릭스 후긴
function c95481906.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c95481906.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95481906,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c95481906.cptg)
	e1:SetOperation(c95481906.cpop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetCountLimit(1,95481906)
	e2:SetDescription(aux.Stringid(95481906,1))
	e2:SetCondition(c95481906.descon)
	e2:SetTarget(c95481906.destg)
	e2:SetOperation(c95481906.desop)
	c:RegisterEffect(e2)
	--remove overlay replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(83880087,2))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c95481906.rcon)
	e3:SetOperation(c95481906.rop)
	c:RegisterEffect(e3)
end
function c95481906.rcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return r&REASON_COST>0 and re:IsActivated() and c==rc and c:IsCanRemoveCounter(tp,0x1949,ev,REASON_COST)
end
function c95481906.rop(e,tp,eg,ep,ev,re,r,rp)
	local min=ev&0xffff
	local max=(ev>>16)&0xffff
	local c=e:GetHandler()
	return c:RemoveCounter(tp,0x1949,min,max,REASON_COST)
end
function c95481906.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xd49)
end

function c95481906.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
end
function c95481906.xfilter(c)
	return c:IsType(TYPE_XYZ)
end
function c95481906.matfilter(c)
	return c:IsSetCard(0xd49) and c:IsType(TYPE_MONSTER)
end
function c95481906.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(95481908) then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		if g:GetCount()==0 then return end
		Duel.ConfirmCards(tp,g)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		local code=tc:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(95481509,2))
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_SETCODE)
		e2:SetValue(0xd49)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		c:RegisterEffect(e2)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		if tc:IsType(TYPE_XYZ) then
			c:AddCounter(0x1949,1)
		end
		Duel.ShuffleExtra(1-tp)
	else
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_EXTRA,nil)
		if g:GetCount()==0 then return end
		local tc=g:RandomSelect(tp,1):GetFirst()
		Duel.ConfirmCards(tp,tc)
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		local code=tc:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(95481509,2))
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_SETCODE)
		e2:SetValue(0xd49)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		c:RegisterEffect(e2)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		if tc:IsType(TYPE_XYZ) then
			c:AddCounter(0x1949,1)
		end
	end
end
function c95481906.nfil2(c,tp)
	return c:GetOwner()==1-tp
end
function c95481906.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	return g:IsExists(c95481906.nfil2,1,nil,tp)
end
function c95481906.filter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c95481906.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c95481906.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95481906.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c95481906.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
end
function c95481906.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and (tc:IsFaceup() or tc:IsLocation(LOCATION_GRAVE)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c95481906.tg)
		e1:SetValue(c95481906.atkval)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(c95481906.defval)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_DISABLE)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAIN_SOLVING)
		e4:SetCondition(c95481906.discon)
		e4:SetOperation(c95481906.disop)
		e4:SetLabelObject(tc)
		e4:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e4,tp)
	end
end
function c95481906.tg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c95481906.atkval(e,c)
	return math.ceil(c:GetAttack()/2)
end
function c95481906.defval(e,c)
	return math.ceil(c:GetDefense()/2)
end
function c95481906.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c95481906.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
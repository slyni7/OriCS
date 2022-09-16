--인챈트릭스 프레키아
function c95481907.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c95481907.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95481907,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,95481907)
	e1:SetTarget(c95481907.cptg)
	e1:SetOperation(c95481907.cpop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95481907,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCountLimit(1,95481993)
	e2:SetCondition(c95481907.descon)
	e2:SetTarget(c95481907.destg)
	e2:SetOperation(c95481907.desop)
	c:RegisterEffect(e2)
	--remove overlay replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(83880087,2))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c95481907.rcon)
	e3:SetOperation(c95481907.rop)
	c:RegisterEffect(e3)
end
function c95481907.rcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return r&REASON_COST>0 and re:IsActivated() and c==rc and c:IsCanRemoveCounter(tp,0x1949,ev,REASON_COST)
end
function c95481907.rop(e,tp,eg,ep,ev,re,r,rp)
	local min=ev&0xffff
	local max=(ev>>16)&0xffff
	local c=e:GetHandler()
	return c:RemoveCounter(tp,0x1949,min,max,REASON_COST)
end

function c95481907.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xd49)
end

function c95481907.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
end
function c95481907.cpop(e,tp,eg,ep,ev,re,r,rp)
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
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(95481509,2))
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_SETCODE)
		e2:SetValue(0xd49)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
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
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(95481509,2))
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_SETCODE)
		e2:SetValue(0xd49)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		if tc:IsType(TYPE_XYZ) then
			c:AddCounter(0x1949,1)
		end
	end
end

function c95481907.nfil2(c,tp)
	return c:GetOwner()==1-tp
end
function c95481907.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	return g:IsExists(c95481907.nfil2,1,nil,tp)
end
function c95481907.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c95481907.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
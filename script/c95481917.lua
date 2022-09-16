--인챈트릭스 브리싱가멘
function c95481917.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c95481917.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95481917,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCountLimit(1,95481917)
	e1:SetTarget(c95481917.cptg)
	e1:SetOperation(c95481917.cpop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95481917,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95481983)
	e2:SetCost(c95481917.cost)
	e2:SetCondition(c95481917.condition)
	e2:SetTarget(c95481917.target)
	e2:SetOperation(c95481917.operation)
	c:RegisterEffect(e2)
	--remove overlay replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c95481917.rcon)
	e3:SetOperation(c95481917.rop)
	c:RegisterEffect(e3)
end
function c95481917.matfilter(c)
	return c:IsLinkSetCard(0xd49) and c:IsLinkType(TYPE_LINK)
end
function c95481917.lcheck(g)
	return g:IsExists(c95481917.matfilter,1,nil)
end
function c95481917.filter(c)
	return c:IsFaceup() and (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsType(TYPE_EFFECT))
end
function c95481917.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c95481917.cfilter(c,tp)
	return c:GetOwner()==1-tp
end
function c95481917.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	return g:IsExists(c95481917.cfilter,1,nil,tp)
end
function c95481917.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(c95481917.filter,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and dg:GetCount()>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,dg:GetCount(),e:GetHandler())
	local tc=cg:GetFirst()
	e:SetLabel(0,cg:GetCount())
	Duel.SendtoGrave(cg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,dg,cg:GetCount(),0,0)
end
function c95481917.operation(e,tp,eg,ep,ev,re,r,rp)
	local label,count=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c95481917.filter,tp,0,LOCATION_ONFIELD,count,count,nil)
	if g:GetCount()==count then
		Duel.HintSelection(g)
		local c=e:GetHandler()
		local tc=g:GetFirst()
		while tc do
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
			tc=g:GetNext()
		end
	end
end

function c95481917.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
end
function c95481917.cpop(e,tp,eg,ep,ev,re,r,rp)
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
			c:AddCounter(0x1949,2)
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
			c:AddCounter(0x1949,2)
		end
	end
end
function c95481917.rcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return r&REASON_COST>0 and re:IsActivated() and c==rc and c:IsCanRemoveCounter(tp,0x1949,ev,REASON_COST)
end
function c95481917.rop(e,tp,eg,ep,ev,re,r,rp)
	local min=ev&0xffff
	local max=(ev>>16)&0xffff
	local c=e:GetHandler()
	return c:RemoveCounter(tp,0x1949,min,max,REASON_COST)
end
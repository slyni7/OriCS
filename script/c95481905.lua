--인챈트릭스 무닌
function c95481905.initial_effect(c)
	c:SetSPSummonOnce(95481905)
	--link summon
	aux.AddLinkProcedure(c,c95481905.matfilter(c),1,1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95481905,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c95481905.cpcon)
	e1:SetTarget(c95481905.cptg)
	e1:SetOperation(c95481905.cpop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(95481905,1))
	e2:SetCountLimit(1)
	e2:SetCondition(c95481905.descon)
	e2:SetTarget(c95481905.destg)
	e2:SetOperation(c95481905.desop)
	c:RegisterEffect(e2)
	--remove overlay replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(83880087,2))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c95481905.rcon)
	e3:SetOperation(c95481905.rop)
	c:RegisterEffect(e3)
end
function c95481905.rcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return r&REASON_COST>0 and re:IsActivated() and c==rc and c:IsCanRemoveCounter(tp,0x1949,ev,REASON_COST)
end
function c95481905.rop(e,tp,eg,ep,ev,re,r,rp)
	local min=ev&0xffff
	local max=(ev>>16)&0xffff
	local c=e:GetHandler()
	return c:RemoveCounter(tp,0x1949,min,max,REASON_COST)
end
function c95481905.matfilter(lc)
	return
		function(c)
			return (c:IsLinkSetCard(0xd49) or c:GetOwner()~=lc:GetControler()) and not c:IsLinkType(TYPE_LINK)
		end
end
function c95481905.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c95481905.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
end
function c95481905.matfilter2(c)
	return c:IsSetCard(0xd49) and c:IsType(TYPE_MONSTER)
end
function c95481905.cpop(e,tp,eg,ep,ev,re,r,rp)
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
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(95481509,2))
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_SETCODE)
		e2:SetValue(0xd49)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)
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
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(95481509,2))
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_SETCODE)
		e2:SetValue(0xd49)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)
		if tc:IsType(TYPE_XYZ) then
			c:AddCounter(0x1949,1)
		end
	end
end
function c95481905.nfil2(c,tp)
	return c:GetOwner()==1-tp
end
function c95481905.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	return g:IsExists(c95481905.nfil2,1,nil,tp)
end
function c95481905.filter(c)
	return c:IsSetCard(0xd49) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c95481905.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481905.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c95481905.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95481905.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
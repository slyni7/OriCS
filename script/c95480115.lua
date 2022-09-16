--에퀴녹스 엑자일
function c95480115.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c95480115.condition1)
	e1:SetTarget(c95480115.target1)
	e1:SetOperation(c95480115.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
	--Activate(effect)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c95480115.condition2)
	e3:SetTarget(c95480115.target2)
	e3:SetOperation(c95480115.activate2)
	c:RegisterEffect(e3)
	if not c95480115.global_check then
		c95480115.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(c95480115.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end

function c95480115.mtfilter1(c)
	return c:IsSetCard(0xd5f) and c:IsType(TYPE_MONSTER)
end
function c95480115.mtfilter2(c)
	return c:IsFusionSetCard(0xd5f) and c:IsFusionType(TYPE_MONSTER)
end
function c95480115.mtfilter3(c)
	return c:IsSetCard(0xd5f) and c:IsSynchroType(TYPE_MONSTER)
end
function c95480115.mtfilter4(c)
	return c:IsSetCard(0xd5f) and c:IsXyzType(TYPE_MONSTER)
end
function c95480115.mtfilter5(c)
	return c:IsSetCard(0xd5f) and c:IsLinkType(TYPE_MONSTER)
end
function c95480115.valcheck(e,c)
	local g=c:GetMaterial()
	if c:IsType(TYPE_RITUAL) and g:IsExists(c95480115.mtfilter1,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_FUSION) and g:IsExists(c95480115.mtfilter2,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_SYNCHRO) and g:IsExists(c95480115.mtfilter3,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_XYZ) and g:IsExists(c95480115.mtfilter4,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_LINK) and g:IsExists(c95480115.mtfilter5,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	end
end
function c95480115.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetFlagEffect(95480000)~=0
end
function c95480115.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.IsExistingMatchingCard(c95480115.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c95480115.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function c95480115.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
end

function c95480115.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) 
		and Duel.IsExistingMatchingCard(c95480115.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c95480115.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c95480115.activate2(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
	end
end

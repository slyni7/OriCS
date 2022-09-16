--이브닝 에퀴녹스
function c95480118.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c95480118.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50588353,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95480118)
	e1:SetCondition(c95480118.hspcon)
	e1:SetTarget(c95480118.hsptg)
	e1:SetOperation(c95480118.hspop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1639384,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c95480118.con)
	e2:SetCost(c95480118.cost)
	e2:SetTarget(c95480118.target)
	e2:SetOperation(c95480118.operation)
	c:RegisterEffect(e2)
	if not c95480118.global_check then
		c95480118.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(c95480118.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c95480118.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xd5f)
end
function c95480118.mtfilter1(c)
	return c:IsSetCard(0xd5f) and c:IsType(TYPE_MONSTER)
end
function c95480118.mtfilter2(c)
	return c:IsFusionSetCard(0xd5f) and c:IsFusionType(TYPE_MONSTER)
end
function c95480118.mtfilter3(c)
	return c:IsSetCard(0xd5f) and c:IsSynchroType(TYPE_MONSTER)
end
function c95480118.mtfilter4(c)
	return c:IsSetCard(0xd5f) and c:IsXyzType(TYPE_MONSTER)
end
function c95480118.mtfilter5(c)
	return c:IsSetCard(0xd5f) and c:IsLinkType(TYPE_MONSTER)
end
function c95480118.valcheck(e,c)
	local g=c:GetMaterial()
	if c:IsType(TYPE_RITUAL) and g:IsExists(c95480118.mtfilter1,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_FUSION) and g:IsExists(c95480118.mtfilter2,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_SYNCHRO) and g:IsExists(c95480118.mtfilter3,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_XYZ) and g:IsExists(c95480118.mtfilter4,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_LINK) and g:IsExists(c95480118.mtfilter5,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	end
end

function c95480118.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c95480118.hspfilter(c,e,tp)
	return c:IsSetCard(0xd5f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480118.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c95480118.hspfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c95480118.hspop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c95480118.hspfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c95480118.hspfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local sg=Group.CreateGroup()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if g1:GetCount()>0 and (g2:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(95480118,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if ft>1 and g2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(95480118,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end

function c95480118.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c95480118.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c95480118.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c95480118.filter(c)
	return c:IsFaceup() and c:GetFlagEffect(95480000)~=0
end
function c95480118.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c95480118.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c95480118.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c95480118.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c95480118.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c95480118.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c95480118.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer() and re:IsActivated()
end

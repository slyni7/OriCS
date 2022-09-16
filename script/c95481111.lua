--아르스 게티아 - 아가레스
function c95481111.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,95481111+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c95481111.sprcon)
	e2:SetOperation(c95481111.sprop)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11522979,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,95481189)
	e4:SetTarget(c95481111.destg)
	e4:SetOperation(c95481111.desop)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(95481111,3))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c95481111.cost)
	e5:SetTarget(c95481111.target)
	e5:SetOperation(c95481111.operation)
	c:RegisterEffect(e5)
	--summon with 3 tribute
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e6:SetCondition(c95481111.ttcon)
	e6:SetOperation(c95481111.ttop)
	e6:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_LIMIT_SET_PROC)
	e7:SetCondition(c95481111.setcon)
	c:RegisterEffect(e7)
end
c95481111.arsget_tribute=3
function c95481111.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c95481111.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c95481111.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c95481111.nfil11(c,sc,tp)
	return ((c:IsReleasable() and c:IsLocation(LOCATION_HAND+LOCATION_MZONE))
		or (c:IsAbleToRemoveAsCost() and c:IsLocation(LOCATION_GRAVE)
			and c:IsSetCard(0xd5c) and sc:IsHasEffect(95481113,tp))) and c:IsLevelAbove(1) and c:IsSummonableCard()
end
function c95481111.nfil12(c,tp,g,sg,sc)
	sg:AddCard(c)
	local res=false
	if sg:CheckWithSumGreater(Card.GetLevel,sc:GetLevel()) then
		res=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or sg:IsExists(c95481111.nfil13,1,nil,tp)
	else
		res=g:IsExists(c95481111.nfil12,1,sg,tp,g,sg,sc)
	end
	sg:RemoveCard(c)
	return res
end
function c95481111.nfil13(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c95481111.sprcon(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c95481111.nfil11,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c,c,tp)
	local sg=Group.CreateGroup()
	return g:IsExists(c95481111.nfil12,1,nil,tp,g,sg,c)
end
function c95481111.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c95481111.nfil11,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c,c,tp)
	local sg=Group.CreateGroup()
	while not sg:CheckWithSumGreater(Card.GetLevel,c:GetLevel()) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mg=g:FilterSelect(tp,c95481111.nfil12,1,1,sg,tp,g,sg,c)
		sg:Merge(mg)
	end
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	sg:Sub(rg)
	if #rg>0 then
		local te=c:IsHasEffect(95481113,tp)
		te:UseCountLimit(tp)
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.Release(sg,REASON_COST)
end

function c95481111.rmfilter(c)
	return c:IsAbleToRemove()
end
function c95481111.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481111.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(c95481111.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c95481111.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c95481111.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end

function c95481111.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsReleasable,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsReleasable,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c95481111.desfilter(c)
	return c:IsFacedown()
end
function c95481111.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and c95481111.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95481111.desfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c95481111.desfilter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c95481111.limit(g:GetFirst()))
	end
end
function c95481111.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c95481111.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end

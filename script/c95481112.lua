--아르스 게티아 - 바엘
function c95481112.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c95481112.con0)
	e0:SetOperation(c95481112.op0)
	c:RegisterEffect(e0)
	aux.AddContactFusionProcedure(c,c95481112.pfil1(c),LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c95481112.pop1,c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65884091,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c95481112.cost1)
	e1:SetOperation(c95481112.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,95481112)
	e2:SetCost(c95481112.cost2)
	e2:SetTarget(c95481112.destg)
	e2:SetOperation(c95481112.desop)
	c:RegisterEffect(e2)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c95481112.splimit)
	c:RegisterEffect(e3)
end
function c95481112.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c95481112.pfil1(fc)
	return
		function(c)
			if c:IsLocation(LOCATION_HAND+LOCATION_MZONE) then
				return c:IsReleasable() and c:IsType(TYPE_MONSTER)
			end
			local tp=fc:GetControler()
			if fc:IsHasEffect(95481113,tp) then
				return c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost()
			end
			return false
		end
end
function c95481112.pop1(g,c)
	local tp=c:GetControler()
	local rg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	g:Sub(rg)
	if #rg>0 then
		local te=c:IsHasEffect(95481113,tp)
		te:UseCountLimit(tp)
	end
	Duel.Release(g,REASON_COST)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c95481112.nfil01(c,fc)
	return c:IsCanBeFusionMaterial(fc) and c:IsFusionSetCard(0xd5c)
end
function c95481112.nfil02(c,tp,mg,sg,fc,sub,chkf)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<5 then
		res=mg:IsExists(c95481112.nfil02,1,sg,tp,mg,sg,fc,sub,chkf)
	else
		res=sg:GetClassCount(Card.GetCode)==5
	end
	sg:RemoveCard(c)
	return res
end
function c95481112.con0(e,g,gc,chkfnf)
	if not g then
		return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_MATERIAL)
	end
	local chkf=chkfnf&0xff
	local c=e:GetHandler()
	local tp=c:GetControler()
	local nf=chkfnf>>8~=0
	local mg=g:Filter(c95481112.nfil01,c,c)
	local sg=Group.CreateGroup()
	if gc then
		if not mg:IsContains(gc) then
			return false
		end
		return c95481112.nfil02(gc,tp,mg,sg,c,true,chkf)
	end
	return mg:IsExists(c95481112.nfil02,1,nil,tp,mg,sg,c,true,chkf)
end
function c95481112.op0(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local chkf=chkfnf&0xff
	local c=e:GetHandler()
	local tp=c:GetControler()
	local nf=chkfnf>>8~=0
	local mg=eg:Filter(c95481112.nfil01,c,c)
	local sg=Group.CreateGroup()
	if gc then
		sg:AddCard(gc)
	end
	while sg:GetCount()<5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local tg=mg:FilterSelect(tp,c95481112.nfil02,1,1,sg,tp,mg,sg,c,true,chkf)
		sg:Merge(tg)
	end
	Duel.SetFusionMaterial(sg)
end

function c95481112.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsReleasable,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsReleasable,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c95481112.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c95481112.efilter)
		c:RegisterEffect(e1)
	end
end
function c95481112.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end


function c95481112.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c95481112.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*1000)
end
function c95481112.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if Duel.Damage(1-tp,ct*300,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end

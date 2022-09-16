--방랑자 안내서: 그대의 여정에 축복을
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,99970810,s.fil)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
	--Negate Normal Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON)
	e2:SetCondition(s.condition2)
	e2:SetCost(s.descost)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
	--Negate Special Summon
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.settg)
	e4:SetOperation(s.setop)
	c:RegisterEffect(e4)
	
	aux.GlobalCheck(s,function()
		s[0]=0
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(s.regcon)
		e1:SetOperation(s.regop1)
		Duel.RegisterEffect(e1,0)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_NEGATED)
		e2:SetCondition(s.regcon)
		e2:SetOperation(s.regop2)
		Duel.RegisterEffect(e2,0)
		aux.AddValuesReset(function()
			s[0]=0
		end)
	end)
	
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.regop1(e,tp,eg,ep,ev,re,r,rp)
	s[0]=s[0]+1
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	if s[0]>0 then
		s[0]=s[0]-1
	end
end
function s.fil(c,fc,sumtype,tp,sub,mg,sg,contact)
	if contact then sumtype=0 end
	return c:IsType(TYPE_FUSION,fc,sumtype,tp) and (not contact or c:IsType(TYPE_MONSTER,fc,sumtype,tp))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
end
function s.cfilter(c)
	return (c:IsOnField() and c:IsReleasable()) or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost())
end
function s.contactop(g)
	local sg=g:Filter(Card.IsOnField,nil)
	g:Sub(sg)
	Duel.Release(sg,REASON_COST+REASON_MATERIAL)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA or (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return tp==1-ep and Duel.GetCurrentChain()==0
end
function s.cfilter2(c)
	return c:IsFacedown() and c:IsAbleToGraveAsCost()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function s.setfilter(c)
	return c:IsSetCard(0x3d6e) and c:IsSSetable(true) and not c:IsType(TYPE_FUSION) and c:IsType(TYPE_MONSTER)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=s[0]
	if chk==0 then return ct and ct>0 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function s.rescon(ft)
	return function(sg,e,tp,mg)
		local fc=sg:FilterCount(Card.IsType,nil,TYPE_FIELD)
		local c1=sg:GetClassCount(Card.GetCode)
		local c2=#sg
		return c1==c2 and fc<=1 and c2-fc<=ft,c1~=c2 or fc>1 or c2-fc>ft
	end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE,0,nil)
	local ct=s[0]
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local tg=aux.SelectUnselectGroup(g,e,tp,1,math.min(ct,ft),s.rescon(ft),1,tp,HINTMSG_SET)
	if #tg==0 or Duel.SSet(tp,tg)==0 then return end
end

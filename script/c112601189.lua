--네버월드 DJ 뉴로
local m=112601189
local cm=_G["c"..m]
function cm.initial_effect(c)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.negcon)
	e3:SetTarget(cm.negtg)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
	--destroy
	kaos.neverworld(c)
end

--negate
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainNegatable(ev)
end
function cm.filter(c,ignore)
	return c:IsSetCard(0xe90) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(ignore)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
	end
end
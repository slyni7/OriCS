--氷結界の龍 ブリューナク
function c95480712.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50321796,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480712+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c95480712.cost)
	e1:SetTarget(c95480712.target)
	e1:SetOperation(c95480712.operation)
	c:RegisterEffect(e1)
end
function c95480712.costfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:GetLevel()==1 and c:IsReleasable()
end
function c95480712.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480712.costfilter,tp,LOCATION_MZONE,0,1,nil) end
	local rt=Duel.GetTargetCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c95480712.costfilter,tp,LOCATION_MZONE,0,1,rt,nil)
	Duel.Release(cg,REASON_COST)
	e:SetLabel(cg:GetCount())
end
function c95480712.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,0,LOCATION_ONFIELD,ct,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
end
function c95480712.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local ct=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
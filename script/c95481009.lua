--보이드 아니마기아스
function c95481009.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd5e),aux.NonTuner(Card.IsSetCard,0xd5e),1,1)
	c:EnableReviveLimit()
	--cannot draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_DRAW)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c95481009.con)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1.95481009)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c95481009.discon)
	e2:SetTarget(c95481009.distg)
	e2:SetOperation(c95481009.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCountLimit(1.95481091)
	e3:SetCondition(c95481009.discon2)
	e3:SetOperation(c95481009.disop2)
	c:RegisterEffect(e3)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(95481009,2))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	e0:SetCondition(c95481008.sprcon)
	e0:SetOperation(c95481008.sprop)
	c:RegisterEffect(e0)
end
function c95481008.tgrfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost()
end
function c95481008.tgrfilter1(c)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0xd5e)
end
function c95481008.tgrfilter2(c)
	return not c:IsType(TYPE_TUNER)
end
function c95481008.mnfilter(c,g)
	return g:IsExists(c95481008.mnfilter2,1,c,c)
end
function c95481008.mnfilter2(c,mc)
	return c:GetLevel()-mc:GetLevel()==7
end
function c95481008.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(c95481008.tgrfilter1,1,nil) and g:IsExists(c95481008.tgrfilter2,1,nil)
		and g:IsExists(c95481008.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c95481008.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c95481008.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c95481008.fselect,2,2,tp,c)
end
function c95481008.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c95481008.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,c95481008.fselect,false,2,2,tp,c)
	Duel.SendtoGrave(tg,REASON_COST)
end

function c95481009.confilter(c)
	return c:IsFaceup() and c:IsCode(95481011)
end
function c95481009.con(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetCurrentPhase()~=PHASE_DRAW and Duel.IsExistingMatchingCard(c95481009.confilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c95481009.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
end
function c95481009.discon2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c95481009.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c95481009.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c95481009.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	local g=Duel.GetMatchingGroup(c95481009.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95481009,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,1,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c95481009.disop2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95481009,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,1,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
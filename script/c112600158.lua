--아다만트의 반란자 시온
local m=112600158
local cm=_G["c"..m]
function cm.initial_effect(c)
	--hand set
	kaos.adamant(c)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetRange(LOCATION_SZONE)
	e4:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(cm.cost)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.activate)
	c:RegisterEffect(e4)
	--grave set
	kaos.admtgrave(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e1:SetCondition(cm.atkcon)
	e1:SetCost(cm.atkcost)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
end

--Activate
function cm.cfilter(c,tp)
	return c:IsSetCard(0xe8a) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,c)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.filter(c)
	return c:IsSetCard(0xe8a) and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=3
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		local rg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		Duel.ConfirmCards(1-tp,rg)
		Duel.ShuffleDeck(tp)
		local tg=rg:GetFirst()
		while tg do
			Duel.MoveSequence(tg,0)
			tg=rg:GetNext()
		end
		Duel.SortDecktop(tp,tp,3)
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end

--atk
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xe8a,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xe8a,2,REASON_COST)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.atktg)
	e1:SetValue(1200)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function cm.atktg(e,c)
	return c:IsSetCard(0xe8a)
end
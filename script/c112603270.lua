--클라이드, Merry-Go-Round.
local m=112603270
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0xe9c)
	--counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCondition(cm.ctcon)
	e0:SetOperation(cm.ctop)
	c:RegisterEffect(e0)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.thcost2)
	e2:SetTarget(cm.thtg2)
	e2:SetOperation(cm.thop2)
	c:RegisterEffect(e2)
	--spsummon
	local e20=Effect.CreateEffect(c)
	e20:SetDescription(aux.Stringid(m,1))
	e20:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e20:SetType(EFFECT_TYPE_IGNITION)
	e20:SetRange(LOCATION_MZONE)
	e20:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e20:SetCountLimit(1,m)
	e20:SetTarget(cm.sptg)
	e20:SetOperation(cm.spop)
	c:RegisterEffect(e20)
end

--counter
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0xe9f) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xe9c,1)
end

--search
function cm.thcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xe9c,5,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xe9c,5,REASON_COST)
end
function cm.thfilter2(c)
	return c:IsSetCard(0xe9f) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

--spsummon
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_CYBERSE) and c:IsLocation(LOCATION_EXTRA)
end
function cm.rmfilter(c)
	return c:IsSetCard(0xe9f) and c:IsAbleToRemoveAsCost()
end
function cm.filter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:GetCode()~=m and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.rmfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.rmfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local td=g:GetFirst()
		if td and Duel.SpecialSummonStep(td,0,tp,tp,false,false,POS_FACEUP) then
			local c=e:GetHandler()
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e3:SetValue(LOCATION_REMOVED)
			tc:RegisterEffect(e3,true)
			end
			Duel.SpecialSummonComplete()
		end
end
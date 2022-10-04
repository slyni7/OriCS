--네버월드 리컨스트럭션
local m=112604125
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCountLimit(1,m,EFFECT_COUNT_CODE_OATH)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.thtg2)
	e2:SetOperation(cm.thop2)
	c:RegisterEffect(e2)

	--self remove+
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1,m,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.setcost)
	e1:SetTarget(cm.target2)
	e1:SetOperation(cm.activate2)
	c:RegisterEffect(e1)

	--self remove+
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCountLimit(1,m,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.setcost2)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	
end

cm.listed_series={0xe7a,0xe90,0xe72}
cm.listed_names={112601198}

function cm.thfilter2(c)
	return c:IsSetCard(0xe7a) and c:IsAbleToGrave()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

function cm.cosfilter(c)
	return c:IsSetCard(0xe7a) and c:IsAbleToRemoveAsCost()
end

function cm.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cosfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cosfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.filter2(c,tp)
	return c:IsType(TYPE_FIELD) and c:IsCode(112601198) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then Duel.RegisterFlagEffect(tp,CARD_MAGICAL_MIDBREAKER,RESET_CHAIN,0,1) end
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local tc=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
end


function cm.cosfilter2(c)
	return c:IsSetCard(0xe90) and c:IsAbleToRemoveAsCost() and not c:IsCode(m)
end

function cm.setcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cosfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cosfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.filter(c,e,tp)
	return (c:IsSetCard(0xe72) or c:IsSetCard(0xe9f) or c:IsSetCard(0xe92))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--시간 쇄도
function c95481315.initial_effect(c)
	aux.AddCodeList(c,25290459)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95481315)
	e1:SetCost(c95481315.cost)
	e1:SetTarget(c95481315.target)
	e1:SetOperation(c95481315.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c95481315.reptg)
	e2:SetValue(c95481315.repval)
	e2:SetOperation(c95481315.repop)
	c:RegisterEffect(e2)
end

function c95481315.costfilter(c,e,tp)
	if not c:IsSetCard(0x41) or not c:IsLevelBelow(4) or not c:IsAbleToGraveAsCost() then return false end
	local code=c:GetCode()
	local class=_G["c"..code]
	if class==nil or class.lvupcount==nil then return false end
	return Duel.IsExistingMatchingCard(c95481315.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,class,e,tp)
end
function c95481315.spfilter(c,class,e,tp)
	local code=c:GetCode()
	for i=1,class.lvupcount do
		if code==class.lvup[i] then	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	end
	return false
end
function c95481315.cfilter(c)
	return c:IsCode(25290459) and c:IsAbleToGraveAsCost()
end
function c95481315.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481315.costfilter,tp,LOCATION_DECK,0,1,nil,e,tp) 
		and Duel.IsExistingMatchingCard(c95481315.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c95481315.costfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local g2=Duel.SelectMatchingCard(tp,c95481315.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SendtoGrave(g2,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end
function c95481315.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c95481315.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	local class=_G["c"..code]
	if class==nil or class.lvupcount==nil then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95481315.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,class,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		if tc:GetPreviousLocation()==LOCATION_DECK then Duel.ShuffleDeck(tp) end
	end
end

function c95481315.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x41) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp)
end
function c95481315.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c95481315.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(95481315,0))
end
function c95481315.repval(e,c)
	return c95481315.repfilter(c,e:GetHandlerPlayer())
end
function c95481315.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end


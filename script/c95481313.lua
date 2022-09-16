--여명을 밝히는 용 LV6
function c95481313.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(38331564,1))
	e1:SetCategory(CCATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c95481313.destg)
	e1:SetOperation(c95481313.desop)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(980973,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCondition(c95481313.spcon)
	e3:SetCost(c95481313.spcost)
	e3:SetTarget(c95481313.sptg)
	e3:SetOperation(c95481313.spop)
	c:RegisterEffect(e3)
	--reg
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetOperation(c95481313.regop)
	c:RegisterEffect(e6)
	local e4=e6:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e6:Clone()
	e5:SetCode(EVENT_FLIP)
	c:RegisterEffect(e5)
end

c95481313.lvupcount=1
c95481313.lvup={95481314}
c95481313.lvdncount=2
c95481313.lvdn={95481312,95481311}

function c95481313.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(95481313,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
end

function c95481313.filter(c,def)
	return c:IsFaceup() and (c:GetDefense()<=def or c:GetAttack<=def)
end
function c95481313.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c95481313.filter,tp,0,LOCATION_MZONE,1,nil,c:GetDefense()) end
	local g=Duel.GetMatchingGroup(c95481313.filter,tp,0,LOCATION_MZONE,nil,c:GetDefense())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c95481313.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c95481313.filter,tp,0,LOCATION_MZONE,1,1,nil,c:GetDefense())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function c95481313.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():GetFlagEffect(95481313)==0
end
function c95481313.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c95481313.spfilter(c,e,tp)
	return c:IsCode(95481314) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c95481313.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c95481313.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c95481313.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95481313.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
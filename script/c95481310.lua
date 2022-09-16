--세크메티의 혜안조 LV 8
function c95481310.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95481310,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,95481310)
	e2:SetCondition(c95481310.spcon)
	e2:SetCost(c95481310.spcost)
	e2:SetTarget(c95481310.sptg)
	e2:SetOperation(c95481310.spop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c95481310.target)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c95481310.target)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--handes
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,95481390)
	e5:SetCondition(c95481310.spcon2)
	e5:SetCost(c95481310.spcost2)
	e5:SetTarget(c95481310.sptg3)
	e5:SetOperation(c95481310.spop3)
	c:RegisterEffect(e5)
end

c95481310.lvup={95481309}
c95481310.lvdn={95481309,95481308}

function c95481310.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c95481310.costfilter(c,e,tp)
	if not c:IsSetCard(0x41) or not c:IsAbleToGraveAsCost() or not c:IsFaceup() then return false end
	local code=c:GetCode()
	local class=_G["c"..code]
	if class==nil or class.lvupcount==nil then return false end
	return Duel.IsExistingMatchingCard(c95481310.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,class,e,tp)
end
function c95481310.spfilter(c,class,e,tp)
	local code=c:GetCode()
	for i=1,class.lvupcount do
		if code==class.lvup[i] then	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	end
	return false
end
function c95481310.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481310.costfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c95481310.costfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end
function c95481310.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c95481310.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	local class=_G["c"..code]
	if class==nil or class.lvupcount==nil then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95481310.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,class,e,tp)
	local tc=g:GetFirst()
	if tc then
		local atk=tc:GetAttack()
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		Duel.Recover(tp,atk,REASON_EFFECT)
		if tc:GetPreviousLocation()==LOCATION_DECK then Duel.ShuffleDeck(tp) end
	end
end

function c95481310.target(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsSetCard(0x41)
end


function c95481310.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (rp~=tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp 
		and c:IsPreviousLocation(LOCATION_ONFIELD)) or c:IsReason(REASON_BATTLE)
end
function c95481310.spfilter4(c)
    return c:IsCode(95481309) and c:IsAbleToRemoveAsCost()
end
function c95481310.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c95481310.spfilter4,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c95481310.spfilter4,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c95481310.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsStatus(STATUS_PROC_COMPLETE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c95481310.spop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end
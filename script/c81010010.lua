--MMJ2
function c81010010.initial_effect(c)
	--special summon 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81010010,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81010010)
	e1:SetCondition(c81010010.spcon)
	c:RegisterEffect(e1)
	
	--special summon 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010010,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81010011)
	e2:SetCost(c81010010.spcost)
	e2:SetTarget(c81010010.sptg)
	e2:SetOperation(c81010010.spop)
	c:RegisterEffect(e2)	
end

--summon
function c81010010.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca1)
end
function c81010010.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81010010.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

--revive
function c81010010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end

function c81010010.sfil(c,e,tp)
	return c:IsSetCard(0xca1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(81010010)
end
function c81010010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c81010010.sfil(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c81010010.sfil,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECT,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81010010.sfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c81010010.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

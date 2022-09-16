--드라코센드 타우로스
function c95480502.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46659709,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,95480502)
	e1:SetCost(c95480502.spcost)
	e1:SetTarget(c95480502.sptg)
	e1:SetOperation(c95480502.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84899094,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95480598)
	e2:SetTarget(c95480502.sptg2)
	e2:SetOperation(c95480502.spop2)
	c:RegisterEffect(e2)
end

function c95480502.cfilter(c)
	return c:IsSetCard(0xd5b) and c:IsLinkState()
end
function c95480502.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c95480502.cfilter,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,c95480502.cfilter,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c95480502.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c95480502.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function c95480502.spfilter(c,e,tp,zone)
	return c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c95480502.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=Duel.GetLinkedZone(tp)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c95480502.spfilter(chkc,e,tp,zone) end
	if chk==0 then return zone~=0
		and Duel.IsExistingTarget(c95480502.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectTarget(tp,c95480502.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,0)
end
function c95480502.spop2(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end

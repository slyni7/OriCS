--알피스트 에퀴녹스콜
function c95480103.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95480103,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,95480103)
	e1:SetCost(c95480103.cost)
	e1:SetTarget(c95480103.target)
	e1:SetOperation(c95480103.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95480103,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,95480103)
	e2:SetCost(c95480103.spcost)
	e2:SetTarget(c95480103.sptg)
	e2:SetOperation(c95480103.spop)
	c:RegisterEffect(e2)
end

function c95480103.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c95480103.tfilter(c,att,e,tp)
	return c:IsSetCard(0xd5a) and c:IsAttribute(att) and c:IsType(TYPE_FUSION) 
		and c:IsLevelBelow(10) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c95480103.filter(c,e,tp,ec)
	return c:IsFaceup() and c:IsSetCard(0xd5f)
		and Duel.IsExistingMatchingCard(c95480103.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute(),e,tp)
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,ec),c)>0
end
function c95480103.chkfilter(c,att)
	return c:IsFaceup() and c:IsSetCard(0xd5f) and c:IsAttribute(att)
end
function c95480103.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c95480103.chkfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(c95480103.filter,tp,LOCATION_MZONE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c95480103.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetLabel(g:GetFirst():GetAttribute())
end
function c95480103.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local att=tc:GetAttribute()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c95480103.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,att,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	end
end


function c95480103.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c95480103.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=Duel.GetLinkedZone(tp)
	if chk==0 then 
		return zone~=0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c95480103.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(tp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and zone>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
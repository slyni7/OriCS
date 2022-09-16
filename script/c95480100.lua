--프라임 에퀴녹스
function c95480100.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c95480100.matfilter,1,1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50588353,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,95480100)
	e1:SetTarget(c95480100.hsptg)
	e1:SetOperation(c95480100.hspop)
	c:RegisterEffect(e1)
end
function c95480100.matfilter(c)
	return c:IsLinkSetCard(0xd5f) and not c:IsCode(95480100)
end
function c95480100.hspfilter(c,e,tp,zone)
	return c:IsSetCard(0xd5f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c95480100.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chk==0 then 
		return zone~=0 and Duel.IsExistingTarget(c95480100.hspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95480100.hspfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c95480100.hspop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and zone>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
	end
end
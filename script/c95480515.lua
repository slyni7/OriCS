--드라코센드 사인
function c95480515.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84899094,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,95480515)
	e2:SetTarget(c95480515.sptg2)
	e2:SetOperation(c95480515.spop2)
	c:RegisterEffect(e2)
	--inactivatable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(c95480515.effectfilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(c95480515.effectfilter)
	c:RegisterEffect(e4)
end
function c95480515.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsRace(RACE_WYRM) and bit.band(loc,LOCATION_MZONE)~=0 and te:GetHandler():GetMutualLinkedGroupCount()>0
end
function c95480515.spfilter(c,e,tp,zone)
	return c:IsSetCard(0xd5b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c95480515.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=Duel.GetLinkedZone(tp)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c95480515.spfilter(chkc,e,tp,zone) end
	if chk==0 then return zone~=0
		and Duel.IsExistingTarget(c95480515.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectTarget(tp,c95480515.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,0)
end
function c95480515.spop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local zone=Duel.GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
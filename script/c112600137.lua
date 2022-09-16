--欺界裝置(마키나)/正規/001(토모)
function c112600137.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c112600137.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112600137,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,112600137)
	e1:SetCondition(c112600137.spcon1)
	e1:SetTarget(c112600137.sptg)
	e1:SetOperation(c112600137.spop)
	c:RegisterEffect(e1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112600137,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c112600137.spcost2)
	e2:SetTarget(c112600137.sptg2)
	e2:SetOperation(c112600137.spop2)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c112600137.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,112600137)
	e4:SetCondition(c112600137.tkcn)
	e4:SetTarget(c112600137.tktg)
	e4:SetOperation(c112600137.tkop)
	c:RegisterEffect(e4)
end
function c112600137.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xe89,TYPE_LINK)
end
function c112600137.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c112600137.filter(c,e,tp)
	return c:IsSetCard(0xe89) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112600137.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c112600137.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c112600137.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112600137.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c112600137.cfilter(c,g,tp,zone)
	return c:IsSetCard(0xe89) and g:IsContains(c)
		and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c112600137.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c112600137.cfilter,1,nil,lg,tp,zone) end
	local g=Duel.SelectReleaseGroup(tp,c112600137.cfilter,1,1,nil,lg,tp,zone)
	Duel.Release(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c112600137.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112600137.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cc=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and chkc~=cc and c112600137.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c112600137.spfilter1,tp,LOCATION_GRAVE,0,1,cc,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c112600137.spfilter1,tp,LOCATION_GRAVE,0,1,1,cc,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c112600137.spop2(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c112600137.indcon(e)
	return e:GetHandler():IsLinkState()
end
function c112600137.tkcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
	and bit.band(c:GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c112600137.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,112600134,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c112600137.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,112600134,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) then
		return
	end
	local token=Duel.CreateToken(tp,112600134)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
--欺界裝置(마키나)/正規/千/095(알레프)
function c112600145.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_EARTH),2,2,c112600145.lcheck)
	c:EnableReviveLimit()
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112600145,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c112600145.tgcon)
	e3:SetTarget(c112600145.tgtg)
	e3:SetOperation(c112600145.tgop)
	c:RegisterEffect(e3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112600145,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,112600145)
	e1:SetCondition(c112600145.spcon)
	e1:SetCost(c112600145.spcost)
	e1:SetTarget(c112600145.sptg)
	e1:SetOperation(c112600145.spop)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c112600145.tartg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,112600145)
	e4:SetCondition(c112600145.tkcn)
	e4:SetTarget(c112600145.tktg)
	e4:SetOperation(c112600145.tkop)
	c:RegisterEffect(e4)
end
function c112600145.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xe89)
end
function c112600145.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c112600145.tgfilter(c)
	return c:IsSetCard(0xe89) and c:IsAbleToGrave()
end
function c112600145.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112600145.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c112600145.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c112600145.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c112600145.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c112600145.spcfilter(c,tp,zone)
	return c:IsSetCard(0xe89) and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c112600145.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c112600145.spcfilter,1,c,tp,zone) end
	local g=Duel.SelectReleaseGroup(tp,c112600145.spcfilter,1,1,c,tp,zone)
	Duel.Release(g,REASON_COST)
end
function c112600145.spfilter(c,e,tp)
	return c:IsSetCard(0xe89) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112600145.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112600145.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c112600145.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112600145.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c112600145.tartg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0xe89) and c:IsType(TYPE_MONSTER)
end
function c112600145.tkcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
	and bit.band(c:GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c112600145.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,112600129,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c112600145.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,112600129,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) then
		return
	end
	local token=Duel.CreateToken(tp,112600129)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
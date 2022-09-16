--ジャンク·デストロイヤー
function c95481414.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,c95481414.ffilter,3,false,false)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,95481414)
	e2:SetCondition(c95481414.spcon)
	e2:SetTarget(c95481414.sptg)
	e2:SetOperation(c95481414.spop)
	c:RegisterEffect(e2)
	--handes
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,95481486)
	e4:SetCondition(c95481414.hdcon)
	e4:SetTarget(c95481414.hdtg)
	e4:SetOperation(c95481414.hdop)
	c:RegisterEffect(e4)
end
function c95481414.ffilter(c)
	return c:IsFusionSetCard(0xd51)
end
function c95481414.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c95481414.spfilter(c,e,tp)
	return c:IsAbleToGrave()
end
function c95481414.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481414.spfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c95481414.spfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c95481414.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c95481414.spfilter,tp,0,LOCATION_MZONE,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	Duel.BreakEffect()
	local mg,matk=og:GetMaxGroup(Card.GetBaseAttack)
	if matk>0 then
		Duel.Damage(1-tp,matk,REASON_EFFECT)
	end
end
function c95481414.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c95481414.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,1)
end
function c95481414.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(tp,1)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
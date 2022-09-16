--파라바이오트 스펙터
function c95481210.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCountLimit(1,95481210)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCondition(c95481210.hspcon)
	e0:SetOperation(c95481210.hspop)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10813327,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c95481210.tdcon)
	e1:SetTarget(c95481210.tdtg)
	e1:SetOperation(c95481210.tdop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98700941,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetCondition(c95481210.spcon)
	e4:SetTarget(c95481210.sptg)
	e4:SetOperation(c95481210.spop)
	c:RegisterEffect(e4)
	--instant(chain)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10131855,1))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,95481210)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(c95481210.condition)
	e5:SetTarget(c95481210.target)
	e5:SetOperation(c95481210.operation)
	c:RegisterEffect(e5)
end

function c95481210.hspfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd47) and Duel.GetMZoneCount(tp,c)>0
end
function c95481210.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c95481210.hspfilter,1,c,tp)
end
function c95481210.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Duel.SelectReleaseGroupEx(tp,c95481210.hspfilter,1,1,c,tp)
	Duel.Release(sg,REASON_COST)
end

function c95481210.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c95481210.spfilter(c,e,tp)
	return c:IsSetCard(0xd47) and c:IsLevelBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c95481210.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c95481210.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c95481210.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95481210.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		Duel.SendtoDeck(c,1-tp,2,REASON_EFFECT)
		if not c:IsLocation(LOCATION_DECK) then return end
		Duel.ShuffleDeck(1-tp)
		c:ReverseInDeck()
	end
end

function c95481210.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetControler()~=c:GetOwner()
end
function c95481210.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95481210.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(c95481210.tgcon)
	e1:SetOperation(c95481210.tgop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95481210.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetControler()~=c:GetOwner()
end
function c95481210.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end

function c95481210.rfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c95481210.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95481210.rfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c95481210.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER)
end
function c95481210.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd47) and c:IsAbleToDeck()
end
function c95481210.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_REMOVED) and c95481210.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95481210.thfilter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c95481210.thfilter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c95481210.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,1-tp,2,REASON_EFFECT)>0 then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c95481210.repop)
	end
end
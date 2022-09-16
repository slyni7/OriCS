--파라바이오트 디아블
function c95481204.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCountLimit(1,95481204)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCondition(c95481204.hspcon)
	e0:SetOperation(c95481204.hspop)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10813327,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c95481204.tdcon)
	e1:SetTarget(c95481204.tdtg)
	e1:SetOperation(c95481204.tdop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
	--spsummon
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98700941,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetCondition(c95481204.spcon)
	e4:SetTarget(c95481204.sptg)
	e4:SetOperation(c95481204.spop)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(75878039,0))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetTarget(c95481204.thtg)
	e5:SetOperation(c95481204.thop)
	c:RegisterEffect(e5)
end

function c95481204.hspfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd47) and Duel.GetMZoneCount(tp,c)>0
end
function c95481204.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c95481204.hspfilter,1,c,tp)
end
function c95481204.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Duel.SelectReleaseGroupEx(tp,c95481204.hspfilter,1,1,c,tp)
	Duel.Release(sg,REASON_COST)
end

function c95481204.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c95481204.rmfilter(c)
	return c:IsAbleToRemove() and not c:IsType(TYPE_TOKEN)
end
function c95481204.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481204.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c95481204.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c95481204.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c95481204.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0 then
		Duel.SendtoDeck(c,1-tp,2,REASON_EFFECT)
		if not c:IsLocation(LOCATION_DECK) then return end
		Duel.ShuffleDeck(1-tp)
		c:ReverseInDeck()
	end
end

function c95481204.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetControler()~=c:GetOwner()
end
function c95481204.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95481204.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(c95481204.tgcon)
	e1:SetOperation(c95481204.tgop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95481204.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetControler()~=c:GetOwner()
end
function c95481204.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end

function c95481204.thfilter(c)
	return c:IsSetCard(0xd47) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or c:IsFaceup()) and not c:IsCode(95481204)
end
function c95481204.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c95481204.thfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED)
end
function c95481204.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c95481204.thfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,nil)
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g2=g:Select(tp,1,1,nil)
		g1:Merge(g2)
		Duel.SendtoDeck(g1,1-tp,2,REASON_EFFECT)
	end
end


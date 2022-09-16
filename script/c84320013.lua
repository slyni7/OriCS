--유키야마
function c84320013.initial_effect(c)
	c:EnableCounterPermit(0x1234)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(84320013,0))
    e2:SetCode(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCost(c84320013.spcost)
	e2:SetCountLimit(1)
    e2:SetTarget(c84320013.sptg)
    e2:SetOperation(c84320013.spop)
    c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(84320013,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,84320108)
	e3:SetTarget(c84320013.rettg)
	e3:SetOperation(c84320013.retop)
	c:RegisterEffect(e3)
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c84320013.desreptg)
	e4:SetOperation(c84320013.desrepop)
	c:RegisterEffect(e4)
	--Add counter2
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetRange(LOCATION_FZONE)
	e5:SetOperation(c84320013.addop2)
	c:RegisterEffect(e5)
end
function c84320013.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1234,4,REASON_COST) end
   Duel.RemoveCounter(tp,1,1,0x1234,4,REASON_COST)
end
function c84320013.spfilter(c,e,tp)
   return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7a0) or c:IsCode(59438930) or c:IsCode(55623480) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
       and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c84320013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
      and Duel.IsExistingMatchingCard(c84320013.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c84320013.spop(e,tp,eg,ep,ev,re,r,rp)
   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   local g=Duel.SelectMatchingCard(tp,c84320013.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
   if g:GetCount()~=0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
   end
end
function c84320013.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x7a0) or c:IsCode(59438930) or c:IsCode(55623480) and c:IsAbleToDeck()
end
function c84320013.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and chkc:IsControler(tp) and c84320013.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c84320013.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c84320013.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),1,1)
end
function c84320013.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c84320013.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0x1234)>0 end
	return Duel.SelectYesNo(tp,aux.Stringid(84320013,1))
end
function c84320013.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x1234,1,REASON_EFFECT)
end
function c84320013.addop2(e,tp,eg,ep,ev,re,r,rp)
	local count=0
	local c=eg:GetFirst()
	while c~=nil do
		if not c:IsCode(84320013) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) then
			count=count+c:GetCounter(0x1234)
		end
		c=eg:GetNext()
	end
	if count>0 then
		e:GetHandler():AddCounter(0x1234,count)
	end
end

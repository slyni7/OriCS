--아르스 게티아 - 바르바토스
function c95481105.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,95481105+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c95481105.sprcon)
	e1:SetOperation(c95481105.sprop)
	c:RegisterEffect(e1)
	--pos
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95481105,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(c95481105.settg)
	e3:SetOperation(c95481105.setop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCountLimit(1,95481105)
	e4:SetCost(c95481105.tgcost)
	e4:SetTarget(c95481105.tgtg)
	e4:SetOperation(c95481105.tgop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
end

function c95481105.nfil11(c,sc,tp)
	return ((c:IsReleasable() and c:IsLocation(LOCATION_HAND+LOCATION_MZONE))
		or (c:IsAbleToRemoveAsCost() and c:IsLocation(LOCATION_GRAVE)
			and c:IsSetCard(0xd5c) and sc:IsHasEffect(95481113,tp))) and c:IsLevelAbove(1) and c:IsSummonableCard()
end
function c95481105.nfil12(c,tp,g,sg,sc)
	sg:AddCard(c)
	local res=false
	if sg:CheckWithSumGreater(Card.GetLevel,sc:GetLevel()) then
		res=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or sg:IsExists(c95481105.nfil13,1,nil,tp)
	else
		res=g:IsExists(c95481105.nfil12,1,sg,tp,g,sg,sc)
	end
	sg:RemoveCard(c)
	return res
end
function c95481105.nfil13(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c95481105.sprcon(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c95481105.nfil11,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c,c,tp)
	local sg=Group.CreateGroup()
	return g:IsExists(c95481105.nfil12,1,nil,tp,g,sg,c)
end
function c95481105.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c95481105.nfil11,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c,c,tp)
	local sg=Group.CreateGroup()
	while not sg:CheckWithSumGreater(Card.GetLevel,c:GetLevel()) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mg=g:FilterSelect(tp,c95481105.nfil12,1,1,sg,tp,g,sg,c)
		sg:Merge(mg)
	end
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	sg:Sub(rg)
	if #rg>0 then
	local te=c:IsHasEffect(95481113,tp)
	te:UseCountLimit(tp)
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.Release(sg,REASON_COST)
end



function c95481105.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c95481105.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c95481105.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c95481105.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c95481105.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

function c95481105.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c95481105.thfilter(c)
	return c:IsSetCard(0xd5c) and c:IsAbleToHand() and not c:IsCode(95481105)
end
function c95481105.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481105.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95481105.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95481105.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

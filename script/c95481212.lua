--파라바이오트 인펙션
function c95481212.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69840739,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c95481212.chcon)
	e1:SetCost(c95481212.discost)
	e1:SetTarget(c95481212.chtg)
	e1:SetOperation(c95481212.chop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c95481212.tdtg)
	e2:SetOperation(c95481212.tdop)
	c:RegisterEffect(e2)
end

function c95481212.rfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_INSECT) and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c95481212.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c95481212.rfilter,tp,0,LOCATION_REMOVED+LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,tp,0,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c95481212.chcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and (re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP or re:GetActiveType()==TYPE_QUICKPLAY) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c95481212.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,0,LOCATION_DECK)>0 end
end
function c95481212.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c95481212.repop)
end

function c95481212.tdfilter(c)
	return c:IsSetCard(0xd47) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or c:IsFaceup())
end
function c95481212.cfilter(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsSetCard(0xd47)
end
function c95481212.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c95481212.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c95481212.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c95481212.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481212.tdfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED)
end
function c95481212.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95481212.tdfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoDeck(tc,1-tp,2,REASON_EFFECT)~=0 then
		Duel.ShuffleDeck(1-tp)
		tc:ReverseInDeck()
	end
end
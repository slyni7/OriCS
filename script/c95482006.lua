--폭풍의 비전술
function c95482006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95482006+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c95482006.cost)
	e1:SetTarget(c95482006.target)
	e1:SetOperation(c95482006.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(95482006,ACTIVITY_CHAIN,c95482006.chainfilter)
end
function c95482006.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0xd40) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY)
end
function c95482006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetCustomActivityCount(95482006,tp,ACTIVITY_CHAIN)<3 end
end
function c95482006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local ct=Duel.GetCustomActivityCount(95482006,tp,ACTIVITY_CHAIN)
	local cc=1
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		ct=ct-1
	end
	if ct>=1 then cc=2 end
	if ct>=2 then cc=3 end
	e:SetCategory(cat)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,cc,nil)
end
function c95482006.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

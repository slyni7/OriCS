--염화의 비전술
function c95482005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95482005+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c95482005.cost)
	e1:SetTarget(c95482005.target)
	e1:SetOperation(c95482005.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(95482005,ACTIVITY_CHAIN,c95482005.chainfilter)
end
function c95482005.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0xd40) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY)
end
function c95482005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetCustomActivityCount(95482005,tp,ACTIVITY_CHAIN)<3 end
end
function c95482005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetCustomActivityCount(95482005,tp,ACTIVITY_CHAIN)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		ct=ct-1
	end
	local cat=CATEGORY_DESTROY
	e:SetCategory(cat)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,TYPE_SPELL)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
end
function c95482005.activate(e,tp,eg,ep,ev,re,r,rp)
	local rct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,TYPE_SPELL)
	if Duel.Damage(1-tp,rct*200,REASON_EFFECT)>0 then
		local ct=Duel.GetCustomActivityCount(95482005,tp,ACTIVITY_CHAIN)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			ct=ct-1
		end
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		if ct>=1 or (ct>=2 and g:GetCount()>0) then
			if ct>=1 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95482005,1)) then
				Duel.BreakEffect()
				Duel.Damage(1-tp,1000,REASON_EFFECT)
			end
			if ct>=2 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95482005,2)) then
				Duel.BreakEffect()
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end

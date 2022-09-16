--명도의 갈라짐
--ヒドゥン・ショット
function c95481413.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c95481413.cost)
	e1:SetTarget(c95481413.target)
	e1:SetOperation(c95481413.activate)
	c:RegisterEffect(e1)
end
function c95481413.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c95481413.costfilter(c)
	return c:IsSetCard(0xd51) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c95481413.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c95481413.costfilter,tp,LOCATION_GRAVE,0,1,nil)
				and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
		else return false end
	end
	e:SetLabel(0)
	local rt=Duel.GetTargetCount(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c95481413.costfilter,tp,LOCATION_GRAVE,0,1,rt,nil)
	local ct=cg:GetCount()
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c95481413.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end

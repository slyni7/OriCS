--滅びの呪文－デス・アルテマ
function c95480817.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480817+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c95480817.condition)
	e1:SetCondition(c95480817.condition)
	e1:SetTarget(c95480817.target)
	e1:SetOperation(c95480817.activate)
	c:RegisterEffect(e1)
end

function c95480817.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd52) and c:IsRankAbove(8)
end
function c95480817.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c95480817.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c95480817.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c95480817.filter(c)
	return c:IsRankAbove(9) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c95480817.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and g1:GetCount()>0 and g2:GetCount()>0
			and Duel.IsExistingMatchingCard(c95480817.filter,tp,LOCATION_MZONE,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg1=g1:RandomSelect(tp,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg2=g2:Select(tp,1,1,nil)
			sg1:Merge(sg2)
			Duel.HintSelection(sg1)
			Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
		end
	end
end

--역천제룡 임페리움 에버틴
function c95480423.initial_effect(c)
	c:SetUniqueOnField(1,0,95480423)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c95480423.mfilter,c95480423.xyzcheck,2,99)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetCondition(c95480423.accon)
	e1:SetOperation(c95480423.op2)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90448279,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c95480423.tgcost)
	e2:SetTarget(c95480423.tgtg)
	e2:SetOperation(c95480423.tgop)
	c:RegisterEffect(e2)
end
function c95480423.mfilter(c,xyzc)
	return c:IsFaceup() and  c:IsXyzType(TYPE_XYZ) and c:IsSetCard(0xd45)
end
function c95480423.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c95480423.accon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c95480423.ofilter2(c,att)
	return c:IsRace(RACE_WYRM) and c:IsAbleToDeck() and c:IsAttribute(att)
end
function c95480423.op2(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp and re:IsActiveType(TYPE_MONSTER) then
		local rc=re:GetHandler()
		local att=rc:GetAttribute()
		if Duel.IsExistingMatchingCard(c95480423.ofilter2,tp,LOCATION_GRAVE,0,1,nil,att) and Duel.SelectYesNo(tp,aux.Stringid(95480423,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,c95480423.ofilter2,tp,LOCATION_GRAVE,0,1,1,nil,att)
			if g:GetCount()>0 then
				Duel.Hint(HINT_CARD,0,95480423)
				Duel.HintSelection(g)
				if Duel.NegateActivation(ev) then
					Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
				end
			end
		end
	end
end
function c95480423.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c95480423.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function c95480423.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--명왕제룡 데우스 모르테
function c95480413.initial_effect(c)
	c:SetUniqueOnField(1,0,95480413)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WYRM),10,2)
	c:EnableReviveLimit()
	--negate activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8165596,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c95480413.negcon)
	e1:SetCost(c95480413.negcost)
	e1:SetTarget(c95480413.negtg)
	e1:SetOperation(c95480413.negop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c95480413.desreptg)
	e2:SetValue(c95480413.desrepval)
	e2:SetOperation(c95480413.desrepop)
	c:RegisterEffect(e2)
end

function c95480413.negcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return ep~=tp
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c95480413.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(ct)
end
function c95480413.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c95480413.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateEffect(ev) and e:GetLabelObject():IsRace(RACE_WYRM) then
		local g=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
		local tc=g:GetFirst()
		if tc and c:IsRelateToEffect(e) then
			Duel.Overlay(c,Group.FromCards(tc))
		end
	end
end

function c95480413.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c95480413.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c95480413.repfilter,1,nil,tp)
		and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c95480413.desrepval(e,c)
	return c95480413.repfilter(c,e:GetHandlerPlayer())
end
function c95480413.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,95480413)
end

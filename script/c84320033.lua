--라인 킬러
function c84320033.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--moving
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84320033,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c84320033.seqcon)
	e1:SetOperation(c84320033.seqop)
	c:RegisterEffect(e1)
	--line destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84320033,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCountLimit(1)
	e2:SetCost(c84320033.setcost)
	e2:SetTarget(c84320033.target)
	e2:SetOperation(c84320033.activate)
	c:RegisterEffect(e2)
end
function c84320033.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c84320033.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	Duel.MoveSequence(c,math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0),2))
end




function c84320033.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c84320033.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   local c=e:GetHandler()
   local g=c:GetColumnGroup()
   if chk==0 then return #g>0 end
   Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c84320033.activate(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   local g=c:GetColumnGroup()
   Duel.Destroy(g,REASON_EFFECT)
end

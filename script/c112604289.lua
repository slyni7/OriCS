--쿠로가네 카노네
local s,id=GetID()
function s.initial_effect(c)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	--Xyz summon procedure
	Xyz.AddProcedure(c,nil,1,2,s.ovfilter,aux.Stringid(id,0),99,s.xyzop)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.cost1)
	e3:SetTarget(s.target1)
	e3:SetOperation(s.operation1)
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.cost2)
	e3:SetTarget(s.target2)
	e3:SetOperation(s.operation2)
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetCountLimit(1,{id,2},EFFECT_COUNT_CODE_OATH)
	e4:SetTarget(s.tar3)
	e4:SetOperation(s.op3)
	c:RegisterEffect(e4)
end
s.listed_series={0xe75}

function s.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsSetCard(0xe75,lc,SUMMON_TYPE_XYZ,tp)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return true end
	return true
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter(c)
	return c:IsSetCard(0xe75) and c:IsAbleToHand()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function s.filter(c)
	return c:IsSetCard(0xe75) and c:IsAbleToHand()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.filter3(c)
	return c:IsSetCard(0xe75) and c:IsAbleToDeck() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1) and g:GetClassCount(Card.GetCode)>=4
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,4,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetClassCount(Card.GetCode)>=4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg3=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg3:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg4=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		sg1:Merge(sg4)
		Duel.HintSelection(sg1)
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
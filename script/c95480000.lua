--THE LAST SALOMON
function c95480000.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c95480000.spcon)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c95480000.adval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--restart
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(91588074,0))
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetTarget(c95480000.rsttg)
	e5:SetOperation(c95480000.rstop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e6)
end
function c95480000.cfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c95480000.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(c95480000.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:GetCount()>=12 and g:GetClassCount(Card.GetCode)==g:GetCount()
end

function c95480000.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND)*500
end

function c95480000.rsttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c95480000.tdfilter,tp,0x7e,0x7e,aux.ExceptThisCard(e))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c95480000.tdfilter(c)
	return (c:IsLocation(0x1e) or (c:IsFaceup() and ((c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_EXTRA)) or (c:IsLocation(LOCATION_REMOVED))))) and c:IsAbleToDeck()
end
function c95480000.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c95480000.tdfilter,tp,0x7e,0x7e,aux.ExceptThisCard(e))
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local tg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK)
	if tg:IsExists(Card.IsControler,1,nil,tp) then Duel.ShuffleDeck(tp) end
	if tg:IsExists(Card.IsControler,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
	Duel.BreakEffect()
	Duel.SetLP(tp,8000)
	Duel.SetLP(1-tp,8000)
	Duel.Draw(tp,5,REASON_EFFECT)
	Duel.Draw(1-tp,5,REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,0)
	e2:SetValue(aux.TRUE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

--欺界裝置(엑스트라 마키나)/水族館(아쿠아리움의 하루)
function c112600155.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112600155,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c112600155.rmtg)
	e1:SetOperation(c112600155.rmop)
	c:RegisterEffect(e1)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112600155,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,112600155)
	e3:SetTarget(c112600155.target)
	e3:SetOperation(c112600155.operation)
	c:RegisterEffect(e3)
	--self destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SELF_DESTROY)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c112600155.descon)
	c:RegisterEffect(e6)
end
function c112600155.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()~=tp and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c112600155.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c112600155.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function c112600155.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.CheckReleaseGroupEx(tp,c112600155.filter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c112600155.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDraw(tp) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then ct=1 end
	if ct>2 then ct=2 end
	local g=Duel.SelectReleaseGroupEx(tp,c112600155.filter,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local rct=Duel.Release(g,REASON_EFFECT)
		Duel.Draw(tp,rct,REASON_EFFECT)
	end
end
function c112600155.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe89) and c:IsType(TYPE_LINK)
end
function c112600155.descon(e)
	return not Duel.IsExistingMatchingCard(c112600155.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
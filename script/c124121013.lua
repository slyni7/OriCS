--영화원의 임볼크
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xfa1),1,1,aux.TRUE,1,1)
	c:EnableReviveLimit()
	--synchro level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetOperation(s.synop)
	c:RegisterEffect(e1)
	--Return 1 opponent's card to Deck
	local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--Banish itself
	local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function() return Duel.IsMainPhase() end)
	e3:SetCost(s.cost)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
	local cicbsm=Card.IsCanBeSynchroMaterial
	function Card.IsCanBeSynchroMaterial(mc,sc,...)
		if mc:GetLevel()==0 and sc==c then
			return true
		end
		return cicbsm(mc,sc,...)
	end
end
function s.synop(e,tg,ntg,sg,lv,sc,tp)
	local res=sg:CheckWithSumEqual(Card.GetSynchroLevel,lv,#sg,#sg,sc) 
		or sg:CheckWithSumEqual(function(c,s)
		if c:IsControler(1-tp) then
			return 7
		else
			return c:GetSynchroLevel(s)
		end
	end,lv,#sg,#sg,sc)
	return res,true
end
function s.cfilter(c)
	return c:IsSetCard(0xfa1) and c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(s.cfilter,tp,tp,LOCATION_HAND+LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,1-tp,LOCATION_ONFIELD,nil)
	if chk==0 then return #g1>0 and #g2>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(s.cfilter,tp,tp,LOCATION_HAND+LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,1-tp,LOCATION_ONFIELD,nil)
	if #g1<1 then return end
	local c1=g:Select(tp,1,1)
	Duel.HintSelection(c1)
	if Duel.SendtoGrave(c1,REASON_EFFECT)>0 and #g2>0 then
		local c2=g:Select(tp,1,1)
		Duel.SendtoDeck(c2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
	end
	Duel.SetChainLimit(aux.FALSE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetTurnCount()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(1000)
	e1:SetLabel(ct)
	e1:SetCondition(s.ocon31)
	e1:SetTarget(s.otar31)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function s.ocon31(e)
	local ct=e:GetLabel()
	return Duel.GetTurnCount()~=ct
end
function s.otar31(e,c)
	return c:IsSetCard(0xfa1)
end
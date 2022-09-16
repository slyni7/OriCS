--영화원의 엔셀리온
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
	--Search 1 monster from your Deck
	local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(function(e,tp) return Duel.IsTurnPlayer(tp) end)
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
		if sc then
			return cicbsm(mc,sc,...)
		else
			return cicbsm(mc)
		end
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
function s.filter(c)
	return c:IsSetCard(0xfa1) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
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
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	e3:SetLabel(ct)
	e3:SetCondition(s.negcon)
	e3:SetOperation(s.negop)
	Duel.RegisterEffect(e3,tp)
end
function s.archfilter(c)
	return c:IsSetCard(0xfa1)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if Duel.GetTurnCount()==ct then
		return false
	end
	local a,b=Duel.GetBattleMonster(tp)
	if a and b and s.archfilter(a)  then
		e:SetLabelObject(b)
		return true
	end
	e:SetLabelObject(nil)
	return false
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc then return end
	-- Negate its effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_DAMAGE)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	tc:RegisterEffect(e2)
end

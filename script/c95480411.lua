--극광제룡 디바이누스 럭스
function c95480411.initial_effect(c)
	c:SetUniqueOnField(1,0,95480411)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WYRM),10,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29515122,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DECKDES+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c95480411.cost)
	e1:SetTarget(c95480411.target)
	e1:SetOperation(c95480411.operation)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetOperation(c95480411.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)
end

function c95480411.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c95480411.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,5) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,5)
end
function c95480411.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsRace(RACE_WYRM)
end
function c95480411.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.DiscardDeck(tp,5,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c95480411.cfilter,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if dg:GetCount()==0 then return end
	Duel.BreakEffect()
	Duel.HintSelection(dg)
	Duel.Destroy(dg,REASON_EFFECT)
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(ct*500)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function c95480411.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local ct=Duel.GetMatchingGroupCount(Card.IsRace,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,RACE_WYRM)*100
	if bc and bc:IsType(TYPE_MONSTER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		bc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		bc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(-ct)
		e3:SetReset(RESET_EVENT+0xff0000)
		bc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(-ct)
		e4:SetReset(RESET_EVENT+0xff0000)
		bc:RegisterEffect(e4)
	end
end
--블루미너스 로터스
function c95481707.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xd50),2,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_MZONE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c95481707.val0)
	c:RegisterEffect(e0)
	--apply effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(c95481707.tg1)
	e1:SetOperation(c95481707.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(95481707,0))
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c95481707.con2)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95481707,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c95481707.con3)
	e3:SetTarget(c95481707.tg3)
	e3:SetOperation(c95481707.op3)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c95481707.con4)
	e4:SetTarget(c95481707.tg4)
	e4:SetOperation(c95481707.op4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
end
function c95481707.val0(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c95481707.con2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c95481707.fil1(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsSetCard(0xd50) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToDeck() then
		if c.bloominus_effect then
			local te=c.bloominus_effect[c]
			local tg=te:GetTarget()
			return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
		end
	end
	return false
end
function c95481707.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c95481707.fil1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c95481707.fil1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	local tc=g:GetFirst()
	local te=tc.bloominus_effect[tc]
	Duel.ClearTargetCard()
	local tg=te:GetTarget()
	if tg then
		tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function c95481707.op1(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=e:GetLabelObject()
	if not te then
		return
	end
	local tc=te:GetHandler()
	if tc:IsRelateToEffect(e) then
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end

function c95481707.con3(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c95481707.fil3(c)
	return c:IsSetCard(0xd50) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c95481707.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481707.fil3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end
function c95481707.op3(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c95481707.fil3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	Duel.Damage(p,d,REASON_EFFECT)
end

function c95481707.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT))) and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c95481707.fil4(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xd50) and c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0 
end
function c95481707.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(c95481707.fil4,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c95481707.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)>0then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c95481707.fil4,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

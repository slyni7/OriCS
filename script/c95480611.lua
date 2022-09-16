--이레귤러: 타임 패러독스
function c95480611.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd57),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,95480611)
	e1:SetCost(c95480611.adcost)
	e1:SetOperation(c95480611.adop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(52714670,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95480689)
	e2:SetCondition(c95480611.rmcon)
	e2:SetTarget(c95480611.rmtg)
	e2:SetOperation(c95480611.rmop)
	c:RegisterEffect(e2)
end

function c95480611.cfilter(c)
	return c:IsSetCard(0xd57) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c95480611.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480611.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c95480611.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	e:SetLabel(tc:GetLevel())
end
function c95480611.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local lv=e:GetLabel()
		--atkdown
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200*lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		--defdown
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end

function c95480611.rmcfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsRace(RACE_PSYCHO)
end
function c95480611.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c95480611.rmcfilter,1,e:GetHandler(),tp)
end
function c95480611.filter(c,e,tp)
	return c:IsSetCard(0xd57) and c:IsFaceup() and  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480611.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_HAND)
end
function c95480611.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:RandomSelect(1-tp,1)
		local tc=sg:GetFirst()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		tc:RegisterFlagEffect(95480611,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCondition(c95480611.retcon)
		e1:SetOperation(c95480611.retop)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.ShuffleHand(1-tp)
end
function c95480611.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(95480611)~=0
end
function c95480611.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
end

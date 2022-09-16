--풀블루미너스 히비스커스
function c95481717.initial_effect(c)
	--fusion procedure
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0xd50),c95481717.mfil1,c95481717.mfil2,nil)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_MZONE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c95481717.val0)
	c:RegisterEffect(e0)
	--apply effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95481708,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c95481717.tg1)
	e1:SetOperation(c95481717.op1)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44665365,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c95481717.con2)
	e2:SetTarget(c95481717.tg2)
	e2:SetOperation(c95481717.op2)
	c:RegisterEffect(e2)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c95481717.con4)
	e4:SetTarget(c95481717.tg4)
	e4:SetOperation(c95481717.op4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
end
function c95481717.mfil1(c)
	return c:IsFusionSetCard(0xd50) and c:IsFusionType(TYPE_FUSION)
end
function c95481717.mfil2(c)
	return c:IsFusionSetCard(0xd50) and c:IsFusionType(TYPE_FUSION) and c:IsLevelAbove(7)
end
function c95481717.val0(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c95481717.fil1(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsSetCard(0xd50) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		if c.bloominus_effect then
			local te=c.bloominus_effect[c]
			local tg=te:GetTarget()
			return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
		end
	end
	return false
end
function c95481717.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c95481717.fil1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95481717.fil1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
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
function c95481717.op1(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=e:GetLabelObject()
	if not te then
		return
	end
	local tc=te:GetHandler()
	if tc:IsRelateToEffect(e) then
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c95481717.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c95481717.fil2(c)
	return c:IsSetCard(0xd50) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c95481717.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481717.fil2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c95481717.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c95481717.fil2,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.NegateActivation(ev)
	end
end

function c95481717.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT))) and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c95481717.fil4(c,e,tp)
	if not (c:IsRace(RACE_PLANT) and not c:IsCode(95481717) and c:IsType(TYPE_FUSION) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	else
		return Duel.GetMZoneCount(tp)>0
	end
end
function c95481717.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481717.fil4,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c95481717.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95481717.fil4,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
--플로리아 단델리온
function c95481716.initial_effect(c)
	c:SetSPSummonOnce(95481716)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0xd50),aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c95481716.con1)
	e1:SetOperation(c95481716.op1)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65536818,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c95481716.tg2)
	e2:SetOperation(c95481716.op2)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88264978,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c95481716.con3)
	e3:SetCost(c95481716.cost3)
	e3:SetTarget(c95481716.tg3)
	e3:SetOperation(c95481716.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c95481716.con4)
	c:RegisterEffect(e4)
	if not c95481716.global_check then
		c95481716.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DISCARD)
		ge1:SetOperation(c95481716.gop1)
		Duel.RegisterEffect(ge1,0)
	end
	if not c95481716.bloominus_effect then
		c95481716.bloominus_effect={}
	end
	c95481716.bloominus_effect[c]=e3
end
function c95481716.gop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsType(TYPE_MONSTER) and tc:GetOriginalRace()==RACE_PLANT and tc:IsPreviousLocation(LOCATION_HAND) then
			if tc:IsPreviousControler(0) then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,95481716,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,95481716,RESET_PHASE+PHASE_END,0,1) end
end
function c95481716.cfil1(c,fc,tp)
	return c:IsSetCard(0xd50) and c:IsFusionType(TYPE_MONSTER) and not c:IsFusionType(TYPE_FUSION)
		and c:IsAbleToRemove() and Duel.GetLocationCountFromEx(tp,tp,c,fc)>0 and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL)
end
function c95481716.con1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,95481716)~=0 and Duel.IsExistingMatchingCard(c95481716.cfil1,tp,LOCATION_MZONE,0,1,nil)
end
function c95481716.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c95481716.cfil1,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c95481716.fil2(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsSetCard(0xd50) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemove() then
		if c.bloominus_effect then
			local te=c.bloominus_effect[c]
			local tg=te:GetTarget()
			return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
		end
	end
	return false
end
function c95481716.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c95481716.fil2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c95481716.fil2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
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
function c95481716.op2(e,tp,eg,ep,ev,re,r,rp,chk)
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

function c95481716.con3(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,95481709)
end
function c95481716.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,95481709)
end
function c95481716.cfil3(c)
	return c:IsRace(RACE_PLANT) and c:IsDiscardable()
end
function c95481716.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481716.cfil1,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c95481716.cfil1,1,1,REASON_COST+REASON_DISCARD)
end
function c95481716.fil3(c)
	return c:IsSetCard(0xd50) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c95481716.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481716.fil3,tp,LOCATION_DECK,0,1,nil) end
end
function c95481716.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c95481716.fil3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end

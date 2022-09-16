--[Aranea]
local m=99970465
local cm=_G["c"..m]
function cm.initial_effect(c)

	--싱크로 소환
	RevLim(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xe14),aux.NonTuner(Card.IsRace,RACE_INSECT),1,99)

	--공격력 증가
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--파괴 대체
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(cm.reptg)
	e4:SetCountLimit(1)
	c:RegisterEffect(e4)
	
	--공수 감소
	local e5=Effect.CreateEffect(c)
	e5:SetD(m,1)
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetCountLimit(1)
	e5:SetOperation(cm.atkop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e6)
	
end

--공격력 증가
function cm.tdfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsAbleToDeck()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0
		and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		if g1:GetCount()>0 then
			local sg=g1:GetFirst()
			while sg do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_DEFENSE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(tc:GetLevel()*100)
				sg:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				sg:RegisterEffect(e2)
				sg=g1:GetNext()
			end
		end
	end
end

--파괴 대체
function cm.repfilter(c)
	return c:IsSetCard(0xe14) and c:IsAbleToGrave()
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(cm.repfilter,tp,LOCATION_DECK,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.repfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
		return true
	else return false end
end

--공수 감소
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-300)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=g:GetNext()
		end
	end
end

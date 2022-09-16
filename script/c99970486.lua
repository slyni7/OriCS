--[Insomnia]
local m=99970486
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	YuL.Activate(c)
	
	--공수 증가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER+RACE_ZOMBIE))
	e2:SetValue(300)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	
	--죽음의 애도
	local e1=MakeEff(c,"Qo","S")
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	
end

--죽음의 애도
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0a) and c:IsRace(RACE_SPELLCASTER)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.rcfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_ZOMBIE)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_ZOMBIE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	Duel.BreakEffect()
	Duel.Damage(1-tp,500,REASON_EFFECT)
end

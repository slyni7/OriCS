--[Aranea]
local m=99970464
local cm=_G["c"..m]
function cm.initial_effect(c)

	--링크 소환
	RevLim(c)
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	
	--수비력 증가 / 튜너 제거
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(cm.tgtg)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_TUNER)
	c:RegisterEffect(e2)
	
	--세트
	local e3=MakeEff(c,"Qo","M")
	e3:SetD(m,0)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m)
	e3:SetCost(spinel.relcost)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)

	--공수 증감
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

--링크 소환
function cm.matfilter(c)
	return c:IsLinkSetCard(0xe14) and not c:IsLinkType(TYPE_LINK)
end

--수비력 증가 / 튜너 제거
function cm.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end

--세트
function cm.filter(c)
	return c:IsSetCard(0xe14) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--공수 증감
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if g1:GetCount()>0 then
		local sg=g1:GetFirst()
		while sg do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(100)
			sg:RegisterEffect(e1)
			sg=g1:GetNext()
		end
	end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-200)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=g:GetNext()
		end
	end
end

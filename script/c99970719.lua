--[ Lava Golem ]
local m=99970719
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--패 발동
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)

	--공수 증가 + 데미지
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
end

--패 발동
function cm.handcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
		and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<PHASE_BATTLE)
end

--공수 증가 + 데미지
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsLavaGolemCard),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsLavaGolemCard),tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		tc:UpdateAttack(1500,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,c)
		tc:UpdateDefense(1500,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,c)
	end
	Duel.BreakEffect()
	Duel.Damage(tp,g:Filter(Card.IsControler,nil,tp):GetCount()*1000,REASON_EFFECT,true)
	Duel.Damage(1-tp,g:Filter(Card.IsControler,nil,1-tp):GetCount()*1000,REASON_EFFECT,true)
	Duel.RDComplete()
end

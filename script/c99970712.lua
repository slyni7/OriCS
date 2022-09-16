--[ Lava Golem ]
local m=99970712
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--라바 골렘
	YuL.AddLavaGolemProcedure(c,cm.con0,m)
	
	--공수 증가
	local e1=MakeEff(c,"FTf","M")
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCL(1)
	WriteEff(e1,1,"NCO")
	c:RegisterEffect(e1)
	
	--재활용
	local e2=MakeEff(c,"I","M")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCL(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	--서치
	local e3=MakeEff(c,"STo")
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(spinel.delay)
	e3:SetCL(1,m)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)

end

--라바 골렘
function cm.con0fil(c)
	return c:IsFaceup() and c:IsLavaGolem()
end
function cm.con0(e,c)
	return Duel.IsExistingMatchingCard(cm.con0fil,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
		or Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
end

--공수 증가
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
end
function cm.cost1fil(c)
	return c:IsFaceup() and c:IsLavaGolemCard() and c:IsType(TYPE_MONSTER) and c:IsAbleToHandAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cost1fil,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.cost1fil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.tar1fil(c)
	return c:IsFaceup() and c:IsLavaGolemCard()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar1fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tar1fil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end

--재활용
function cm.tar2fil(c)
	return c:IsType(TYPE_MONSTER) and c:IsLavaGolemCard() and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tar2fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar2fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.tar2fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op2fil(c)
	return c:IsAbleToGrave() and c:IsLavaGolemCard() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(cm.op2fil,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD,nil)
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and #g>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end

--서치
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.tar3fil(c)
	return c:IsLavaGolemCard() and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar3fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tar3fil,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

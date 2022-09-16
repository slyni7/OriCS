--[Aranea]
local m=99970467
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	YuL.Activate(c)
	
	--서치
	local e1=MakeEff(c,"I","F")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetCountLimit(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--함정 효과 파괴 내성 부여
	local e2=MakeEff(c,"F","F")
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.indtg)
	e2:SetValue(cm.indval)
	c:RegisterEffect(e2)
	
	--수비력 증가
	local e3=MakeEff(c,"I","G")
	e3:SetCategory(CATEGORY_DEFCHANGE)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(aux.exccon)
	e3:SetOperation(cm.defop)
	c:RegisterEffect(e3)
	
end

--서치
function cm.filter(c)
	return c:IsSetCard(0xe14) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end

--함정 효과 파괴 내성 부여
function cm.indtg(e,c)
	return c:IsRace(RACE_INSECT)
end
function cm.indval(e,re,rp)
	return re:IsActiveType(TYPE_TRAP)
end

--수비력 증가
function cm.defop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(1000)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end

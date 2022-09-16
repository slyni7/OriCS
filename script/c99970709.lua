--[ Nosferatu ]
local m=99970709
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--LP 변경
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	WriteEff(e1,1,"NCO")
	c:RegisterEffect(e1)
	
	--서치 / 샐비지 + 데미지
	local e2=MakeEff(c,"I","G")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DAMAGE)
	e2:SetCL(1,m)
	e2:SetCost(aux.bfgcost)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	--데미지 체크
	aux.GlobalCheck(cm,function()
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			cm[0]=0
			cm[1]=0
		end)
	end)

end

--LP 변경
function cm.cost1fil(c)
	return c:IsSetCard(0xe1e) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cost1fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cost1fil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.con1(e)
	return cm[e:GetHandlerPlayer()]>=5000
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,8000)
end

--서치 / 샐비지 + 데미지
function cm.tar2fil(c)
	return c:IsSetCard(0xe1e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar2fil,tp,LSTN("DG"),0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LSTN("DG"))
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.tar2fil,tp,LSTN("DG"),0,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		Duel.Damage(tp,1000,REASON_EFFECT)
	end
end

--데미지 체크
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_EFFECT~=0 or r&REASON_BATTLE~=0 then
		cm[ep]=cm[ep]+ev
	end
end

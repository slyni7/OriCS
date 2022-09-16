--[ Nosferatu ]
local m=99970701
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환 + 덤핑 + 데미지
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetCL(1,m+YuL.dif)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	
	--샐비지
	local e2=MakeEff(c,"Qo","M")
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1,m)
	e2:SetCost(spinel.relcost)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)

	--Nosferatu
	local e66=MakeEff(c,"STf")
	e66:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e66:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e66:SetCode(EVENT_TO_GRAVE)
	WriteEff(e66,66,"TO")
	c:RegisterEffect(e66)
	
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

--데미지 체크
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_EFFECT~=0 or r&REASON_BATTLE~=0 then
		cm[ep]=cm[ep]+ev
	end
end

--특수 소환 + 덤핑 + 데미지
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if #g>1 then return false end
	return #g==0 or (g:GetFirst():IsFaceup() and g:GetFirst():IsSetCard(0xe1e))
end
function cm.tar1fil(c)
	return c:IsSetCard(0xe1e) and c:IsAbleToGrave()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(cm.tar1fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.SelectMatchingCard(tp,cm.tar1fil,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.Damage(tp,1000,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetD(m,0)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end

--샐비지
function cm.tar2fil(c)
	return c:IsAbleToHand() and ((c:IsSetCard(0xe1e) and c:IsType(TYPE_MONSTER)) or (c:IsSetCard(0xe1f) and c:IsType(YuL.ST)))
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm[tp]>=3000 and Duel.IsExistingMatchingCard(cm.tar2fil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(cm.tar2fil,tp,LOCATION_GRAVE,0,nil)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,math.floor(cm[tp]/3000),aux.dncheck,1,tp,HINTMSG_ATOHAND)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

--Nosferatu
function cm.tar66(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function cm.op66(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,1000,REASON_EFFECT)
	Duel.Recover(p,1500,REASON_EFFECT)
end

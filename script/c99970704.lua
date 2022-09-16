--[ Nosferatu ]
local m=99970704
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e1=MakeEff(c,"I","G")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,m+YuL.dif)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	
	--세트한다
	local e2=MakeEff(c,"Qo","M")
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

--특수 소환
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return cm[tp]>=3000
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe1e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHandAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--세트
function cm.tar2fil(c)
	return c:IsSetCard(0xe1f) and c:IsType(YuL.ST) and c:IsSSetable()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm[tp]>=3000 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.tar2fil,tp,LOCATION_DECK,0,1,nil) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.floor(cm[tp]/3000)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.GetMatchingGroup(cm.tar2fil,tp,LOCATION_DECK,0,nil)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,math.min(ct,ft),aux.dncheck,1,tp,HINTMSG_SET)
	if #sg>0 then
		Duel.SSet(tp,sg)
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

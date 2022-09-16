--[ Nosferatu ]
local m=99970703
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환 + 데미지
	local e1=MakeEff(c,"FTo","H")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCL(1,m+YuL.dif)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)

	--드로우
	local e2=MakeEff(c,"Qo","M")
	e2:SetCategory(CATEGORY_DRAW)
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

--특수 소환 + 데미지
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and r&(REASON_BATTLE+REASON_EFFECT)~=0
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,ev)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ev,REASON_EFFECT,true)
		Duel.Damage(tp,ev,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end

--드로우
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=math.floor(cm[tp]/4000)
	if chk==0 then return ct>=1 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.floor(cm[tp]/4000)
	Duel.Draw(tp,ct,REASON_EFFECT)
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

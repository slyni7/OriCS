--[ Nosferatu ]
local m=99970706
local cm=_G["c"..m]
function cm.initial_effect(c)

	--링크 소환
	RevLim(c)
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),3,3,cm.lcheck)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCode(EFFECT_EXTRA_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
	e0:SetTargetRange(1,1)
	e0:SetOperation(cm.extracon)
	e0:SetValue(cm.extraval)
	c:RegisterEffect(e0)
	
	--공격력 증가
	local e1=MakeEff(c,"S","M")
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(cm.con1)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	--효과 내성
	local e3=e1:Clone()
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)

	--회수
	local e2=MakeEff(c,"Qo","M")
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e2,2,"CTO")
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

--링크 소환
cm.curgroup=nil
function cm.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,2,nil,0xe1e,lc,sumtype,tp)
end
function cm.extracon(c,e,tp,sg,mg,lc,og,chk)
	return not cm.curgroup or #(sg&cm.curgroup)<2
end
function cm.extraval(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or sc~=e:GetHandler() then
			return Group.CreateGroup()
		else
			cm.curgroup=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			cm.curgroup:KeepAlive()
			return cm.curgroup
		end
	elseif chk==2 then
		if cm.curgroup then
			cm.curgroup:DeleteGroup()
		end
		cm.curgroup=nil
	end
end

--데미지 체크
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_EFFECT~=0 or r&REASON_BATTLE~=0 then
		cm[ep]=cm[ep]+ev
	end
end

--공격력 증가 / 효과 내성
function cm.con1(e)
	return cm[e:GetHandlerPlayer()]>=3000
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--회수
function cm.cost2fil(c,g,e)
	return g:IsContains(c) or c==e:GetHandler()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,cm.cost2fil,1,false,nil,nil,lg,e) end
	local g=Duel.SelectReleaseGroupCost(tp,cm.cost2fil,1,1,false,nil,nil,lg,e)
	Duel.Release(g,REASON_COST)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,math.floor(cm[tp]/2000)+1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
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

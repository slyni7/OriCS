--별의 조각
local m=18453454
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","HM")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,m)
	WriteEff(e1,1,"CO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1,m)
	e2:SetCost(aux.bfgcost)
	WriteEff(e2,1,"O")
	c:RegisterEffect(e2)
	aux.AddSquareProcedure(c)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_FORCE_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTR(0,1)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","M")
	e4:SetCode(EFFECT_FORCE_MZONE)
	e4:SetTR(0,"E")
	e4:SetValue(cm.val4)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FC","M")
	e5:SetCode(EVENT_ADJUST)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	WriteEff(e5,5,"O")
	c:RegisterEffect(e5)
	if cm.global_check==nil then
		cm.global_check=true
		cm[0]=false
		cm[1]=false
		local ge1=MakeEff(c,"F")
		ge1:SetCode(EFFECT_SPSUMMON_COST)
		ge1:SetTR(0xff,0xff)
		ge1:SetCost(cm.gcost1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"F")
		ge2:SetCode(EFFECT_SUMMON_COST)
		ge2:SetTR(0xff,0xff)
		ge2:SetCost(cm.gcost2)
		Duel.RegisterEffect(ge2,0)
		local ge3=MakeEff(c,"FC")
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetOperation(cm.gop3)
		Duel.RegisterEffect(ge3,0)
	end
end
cm.square_mana={ATTRIBUTE_WATER,ATTRIBUTE_WATER,ATTRIBUTE_WATER,ATTRIBUTE_EARTH,ATTRIBUTE_EARTH,ATTRIBUTE_EARTH}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.gcost1(e,tc,tp)
	cm[0]=true
	return true
end
function cm.gcost2(e,tc,tp)
	cm[1]=true
	return true
end
function cm.gop3(e,tp,eg,ep,v,re,r,rp)
	cm[0]=false
	cm[1]=false
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_DECREASE_TRIBUTE)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetTR("H",0)
	e1:SetCountLimit(1)
	e1:SetValue(0x1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function cm.vvfil3(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_NORMAL) and c:IsLevelAbove(5)
end
function cm.vval31(tp)
	local v=0
	local g=Duel.GMGroup(cm.vvfil3,tp,"M",0,nil)
	local tc=g:GetFirst()
	while tc do
		local seq=tc:GetSequence()
		v=v|(1<<seq)
		tc=g:GetNext()
	end
	return v
end
function cm.vval32(tp,chk)
	local v=0
	local g=Duel.GMGroup(cm.vvfil3,tp,"M",0,nil)
	local tc=g:GetFirst()
	while tc do
		local seq=4-tc:GetSequence()
		v=v|(1<<seq)
		if chk==1 then
			if seq==1 or seq==3 then
				v=v|(1<<((seq+9)/2))
			end
		end
		tc=g:GetNext()
	end
	return v
end
function cm.val3(e,c,fp,rp,r)
	local tp=e:GetHandlerPlayer()
	if cm[0] then
		cm[0]=false
		local v1=cm.vval31(tp)
		local v2=cm.vval32(tp,1)
		if v1>0 then
			return v1|(v2<<16)
		end
	end
	return 0xffffffff
end
function cm.val4(e,c,fp,rp,r)
	local tp=e:GetHandlerPlayer()
	if cm[1] then
		cm[1]=false
	else
		local v1=cm.vval31(tp)
		local v2=cm.vval32(tp,1)
		if v1>0 then
			return v1|(v2<<16)
		end
	end
	return 0xffffffff
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local v=cm.vval32(tp,0)
	if v==0 then
		return
	end
	local sg=Duel.GMGroup(Card.IsSummonType,tp,0,"M",nil,SUMMON_TYPE_SPECIAL)
	local tc=sg:GetFirst()
	local sg2=Group.CreateGroup()
	while tc do
		local seq=tc:GetSequence()
		if seq>4 then
			seq=seq-5
		end
		if ((1<<seq)&v)>0 then
			sg2:AddCard(tc)
		end
		tc=sg:GetNext()
	end
	sg:Sub(sg2)
	local og=Duel.GMGroup(aux.TRUE,tp,0,"M",nil)
	local oc=og:GetFirst()
	while oc do
		local seq=oc:GetSequence()
		if ((1<<seq)&v)>0 then
			v=v-(1<<seq)
		end
		oc=og:GetNext()
	end
	if #sg>0 then
		Duel.Hint(HINT_CARD,0,m)
	end
	while #sg>0 do
		if v==0 then
			break
		end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOZONE)
		local sc=sg:Select(1-tp,1,1,nil):GetFirst()
		local zone=Duel.SelectDisableField(1-tp,1,LSTN("M"),0,0xff-v)
		v=v-zone
		Duel.MoveSequence(sc,math.log(zone,2))
		sg:RemoveCard(sc)
	end
	if #sg>0 then
		Duel.SendtoGrave(sg,REASON_RULE)
		Duel.Readjust()
	end
end
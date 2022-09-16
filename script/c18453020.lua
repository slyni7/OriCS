--바닐라솔트 할
local m=18453020
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTR(1,0)
	e2:SetCondition(cm.con2)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.afil1)
end
function cm.afil1(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)<1
			and Duel.CheckReleaseGroup(tp,aux.TRUE,1,nil)
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	e1:SetTarget(cm.ctar11)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.SelectReleaseGroup(tp,aux.TRUE,1,12,nil)
	Duel.Release(g,REASON_COST)
	g:KeepAlive()
	e:SetLabelObject(g)
end
function cm.ctar11(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLoc("E")
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,-2,0,10,RACE_FAIRY,ATTRIBUTE_EARTH)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocCount(tp,"M")>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,-2,0,10,RACE_FAIRY,ATTRIBUTE_EARTH) then
		c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
		Duel.SpecialSummonStep(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
		local satk=0
		local g=e:GetLabelObject()
		local tc=g:GetFirst()
		while tc do
			local atk=tc:GetTextAttack()
			if atk>0 then
				satk=satk+atk
			end
			tc=g:GetNext()
		end
		g:DeleteGroup()
		satk=math.floor(satk/1000)*1000+1000
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(satk)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function cm.con2(e)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function cm.val2(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLoc("M")
end
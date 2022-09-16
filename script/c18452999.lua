--바닐라솔트 론
local m=18452999
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","H")
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.tar3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","M")
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTR(1,0)
	e4:SetValue(cm.val4)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.afil1)
end
function cm.afil1(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA
end
function cm.con1(e,c,minc)
	if c==nil then
		return true
	end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function cm.con2(e,c,minc)
	if not c then
		return true
	end
	return false
end
function cm.nfil3(c,tp)
	return c:IsControler(tp) or c:IsFaceup()
end
function cm.nfun3(g,tp)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetAttack,3000) and aux.mzctcheckrel(g,tp)
end
function cm.con3(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(cm.nfil3,nil,tp)
	return rg:CheckSubGroup(cm.nfun3,1,#rg,tp) and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)<1
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(cm.nfil3,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,cm.nfun3,true,1,#rg,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else
		return false
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	e1:SetTarget(cm.otar31)
	Duel.RegisterEffect(e1,tp)
end
function cm.otar31(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLoc("E")
end
function cm.val4(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLoc("M")
end
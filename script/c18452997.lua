--바닐라솔트 린
local m=18452997
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTR(1,0)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.afil1)
end
function cm.afil1(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA
end
function cm.nfil1(c,tp)
	return c:IsControler(tp) or c:IsFaceup()
end
function cm.nfun1(g,tp)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetAttack,2000) and aux.mzctcheckrel(g,tp)
end
function cm.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(cm.nfil1,nil,tp)
	return rg:CheckSubGroup(cm.nfun1,1,#rg,tp) and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)<1
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(cm.nfil1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,cm.nfun1,true,1,#rg,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else
		return false
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	e1:SetTarget(cm.otar11)
	Duel.RegisterEffect(e1,tp)
end
function cm.otar11(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLoc("E")
end
function cm.val2(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLoc("M")
end
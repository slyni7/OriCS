--어게인스트 더 커렌트
local m=18453453
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","HM")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetCL(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetCL(1,m)
	e2:SetCost(aux.bfgcost)
	WriteEff(e2,1,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","M")
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCategory(CATEGORY_DESTROY)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function cm.tfil1(c)
	return c:IsSummonable(true,nil) and c:IsLevelAbove(5)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"H",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"H",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not eg:IsContains(c)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(aux.TRUE,tp,"M","M",1,nil)
	end
	local g=Duel.GMGroup(aux.TRUE,tp,"M","M",nil)
	Duel.SOI(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(aux.TRUE,tp,"M","M",nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

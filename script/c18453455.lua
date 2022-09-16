--겨울꽃
local m=18453455
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
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetD(m,2)
	e3:SetCL(1)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FTo","M")
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetD(m,3)
	e4:SetCL(1)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FTo","M")
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetD(m,4)
	e5:SetCL(1)
	WriteEff(e5,5,"NTO")
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
	local b=Duel.IEMCard(cm.tfil1,tp,"H",0,1,nil)
	if chk==0 then
		return true
	end
	local op=aux.SelectEffect(tp,
		{true,aux.Stringid(m,0)},
		{b,aux.Stringid(m,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(0)
	else
		e:SetCategory(CATEGORY_SUMMON)
		Duel.SOI(0,CATEGORY_SUMMON,nil,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local c=e:GetHandler()
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_DECREASE_TRIBUTE)
		e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e1:SetTR("H",0)
		e1:SetCountLimit(1)
		e1:SetValue(0x1)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SMCard(tp,cm.tfil1,tp,"H",0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end
function cm.nfil3(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LSTN("H")) and c:IsType(TYPE_MONSTER)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_NORMAL) and eg:IsExists(cm.nfil3,1,nil,tp) and Duel.GetFlagEffect(tp,m-1)==0
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsAbleToRemove,tp,0,"H",1,nil)
	end
	Duel.SOI(0,CATEGORY_REMOVE,nil,1,1-tp,"H")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"H",nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,m-1,RESET_PHASE+PHASE_END,0,1)
end
function cm.nfil4(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LSTN("M"))
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_NORMAL) and eg:IsExists(cm.nfil4,1,nil,tp) and Duel.GetFlagEffect(tp,m)==0
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsAbleToRemove,tp,0,"O",1,nil)
	end
	Duel.SOI(0,CATEGORY_REMOVE,nil,1,1-tp,"O")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"O",nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.nfil5(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LSTN("G")) and c:IsType(TYPE_MONSTER)
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_NORMAL) and eg:IsExists(cm.nfil5,1,nil,tp) and Duel.GetFlagEffect(tp,m+1)==0
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsAbleToRemove,tp,0,"G",1,nil)
	end
	Duel.SOI(0,CATEGORY_REMOVE,nil,1,1-tp,"G")
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"G",nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
end
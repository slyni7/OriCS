--연금생물학의 극의
local m=18452955
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.nfil1(c)
	return c:IsFaceup() and c:GetAttribute()~=c:GetOriginalAttribute()
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(cm.nfil1,tp,"M",0,1,nil) and rp~=tp and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and Duel.IsChainNegatable(ev)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.cfil2(c)
	return c:IsSetCard("연금생물") and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function cm.cfun2(g,e,tp)
	return aux.dabcheck(g) and Duel.IEMCard(cm.tfil2,tp,"E",0,1,nil,e,tp,g)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GMGroup(cm.cfil2,tp,"MG",0,nil)
	if chk==0 then
		return c:IsAbleToRemoveAsCost() and g:CheckSubGroup(cm.cfun2,5,5,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,cm.cfun2,false,5,5,e,tp)
	rg:AddCard(c)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function cm.tfil2(c,e,tp,g)
	return c:IsRace(RACE_ALCHEMIST) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"E",0,1,1,nil,e,tp,nil)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
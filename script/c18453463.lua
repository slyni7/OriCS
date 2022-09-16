--더미머미 ~엘프~
local m=18453463
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_LIMIT_SET_PROC)
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(SUMMON_TYPE_TRIBUTE)
	e2:SetD(m,1)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S")
	e3:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetD(m,0)
	e3:SetCondition(cm.con3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"S")
	e4:SetCode(EFFECT_SUMMON_COST)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"STf")
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e5,5,"O")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"FTf","M")
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e6,6,"NO")
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function cm.con1(e,c,minc)
	if not c then
		return true
	end
	return false
end
function cm.con2(e,c,minc)
	if c==nil then
		return true
	end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function cm.con3(e,c,minc)
	if c==nil then
		return true
	end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.ocon41(e)
	return e:GetHandler():GetMaterialCount()==0
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE&~RESET_TOFIELD)
	e1:SetValue(1600)
	e1:SetCondition(cm.ocon41)
	c:RegisterEffect(e1)
end
function cm.ofil51(c)
	return c:IsSetCard("더미머미") and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.ofil52(c,e,tp)
	return c:IsSetCard("더미머미") and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IEMCard(cm.ofil51,tp,"D",0,1,nil)
	local b2=Duel.IEMCard(cm.ofil52,tp,"H",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	if not b1 and not b2 then
		return
	end
	local op=aux.SelectEffect(tp,{b1,aux.Stringid(m,2)},{b2,aux.Stringid(m,3)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.ofil51,tp,"D",0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,cm.ofil52,tp,"H",0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.nfil6(c)
	return c:IsSetCard("더미머미") and c:IsFaceup()
end
function cm.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (not re or not re:GetHandler():IsCode(m)) and rp==tp and eg:IsExists(cm.nfil6,1,nil) and not eg:IsContains(c)
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.ofil52,tp,"H",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
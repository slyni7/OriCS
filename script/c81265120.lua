--오덱시즈 유니
--카드군 번호: 0xc91
local m=81265120
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,"R",nil,cm.mat0,cm.mat1)
	
	--오더 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(0x40)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetOperation(cm.op1)
	e1:SetValue(SUMMON_TYPE_ORDER)
	c:RegisterEffect(e1)
	
	--유발
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	
	--유발즉시
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(0x04)
	e4:SetCountLimit(1,m+1)
	e4:SetCost(cm.co4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
cm.CardType_Order=true

--오더 소환
function cm.mat0(c)
	return c:IsRace(RACE_THUNDER)
end
function cm.mat1(c)
	return c:IsRace(RACE_THUNDER) and c:IsType(TYPE_EFFECT)
end
function cm.nfilter1(c,fc,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xc91)
	and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,c,fc)>0
end
function cm.cn1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,cm.nfilter1,1,nil,c,tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,cm.nfilter1,1,1,nil,c,tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_ORDER+REASON_MATERIAL)
end

--유발
function cm.tfilter1(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xc91)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(cm.tfilter1,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x01)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,0x04)<=0 then
		return
	end
	local g=Duel.GetMatchingGroup(cm.tfilter1,tp,0x01,0,nil)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end

--특수 소환
function cm.cfilter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_THUNDER)
end
function cm.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfilter1,tp,0x10,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,0x10,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.xyzfilter1(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0xc91)
end
function cm.ordfilter1(c)
	return c:IsOrderSummonable(nil) and c:IsSetCard(0xc91)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.xyzfilter1,tp,0x40,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.ordfilter1,tp,0x40,0,1,nil)
	if chk==0 then
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetMatchingGroup(cm.xyzfilter1,tp,0x40,0,nil)
	local b2=Duel.GetMatchingGroup(cm.ordfilter1,tp,0x40,0,nil)
	local off=1
	local ops={}
	local opval={}
	if #b1>0 then
		ops[off]=aux.Stringid(m,4)
		opval[off-1]=1
		off=off+1
	end
	if #b2>0 then
		ops[off]=aux.Stringid(m,5)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then
		return
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=b1:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,sg:GetFirst(),nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=b2:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		Duel.SpecialSummonRule(tp,tc,tc:GetSummonType())
	end
end

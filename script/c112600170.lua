--아다만트의 ハヤタシ(하야다시) 커넥트
local m=112600170
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,112500000,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT),1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe8d))
	e5:SetValue(500)
	c:RegisterEffect(e5)
	--defup
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe8a))
	e6:SetValue(500)
	c:RegisterEffect(e6)
	--to hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e0:SetTarget(cm.thtg)
	e0:SetOperation(cm.thop)
	c:RegisterEffect(e0)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target2)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--hand set
	kaos.adamant(c)
	--grave set
	kaos.admtgrave(c)
end

--special summon rule
function cm.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0xe8a) and re:IsActiveType(TYPE_EFFECT)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE)
end
function cm.spfilter(c,fc,tp)
	return c:IsRace(RACE_PLANT) and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_FUSION)
		and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,c,fc)>0
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)~=0
		and Duel.CheckReleaseGroup(tp,cm.spfilter,1,nil,c,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,cm.spfilter,1,1,nil,c,tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end

--to hand
function cm.thfilter(c,tp)
	return (c:IsSetCard(0xe8d) and c:IsType(TYPE_SPELL)) or (c:IsSetCard(0xe8a) and c:IsType(TYPE_MONSTER) and c:IsAttack(0)) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--disable spsummon
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function cm.filter3(c)
	return c:IsSetCard(0xe8a) or c:IsSetCard(0xe8d)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end
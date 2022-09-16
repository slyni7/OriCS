--개념과 지식의 마녀(아트릭시아) 시아메트
local m=112604012
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
	--atkup
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetValue(cm.atkup)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e1)
	--remove
	local e30=Effect.CreateEffect(c)
	e30:SetDescription(aux.Stringid(m,0))
	e30:SetCategory(CATEGORY_REMOVE)
	e30:SetType(EFFECT_TYPE_QUICK_O)
	e30:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e30:SetCode(EVENT_FREE_CHAIN)
	e30:SetRange(LOCATION_MZONE)
	e30:SetCountLimit(1)
	e30:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e30:SetTarget(cm.rmtg)
	e30:SetOperation(cm.rmop)
	c:RegisterEffect(e30)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
end

cm.CardType_ExRitual=true

--atkup
function cm.atkup(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_RITUAL)*900
end

--remove
function cm.rmfilter1(c,tp)
	local lvl=c:GetLevel()
	return c:IsSetCard(0xe7c) and c:IsType(TYPE_RITUAL) and (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_ONFIELD)) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(cm.rmfilter2,tp,0,LOCATION_MZONE,1,nil,lvl)
end
function cm.rmfilter2(c,lvl)
	return c:IsFaceup() and c:IsLevel(lvl) and c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(tp) and c11270236.rmfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.rmfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,cm.rmfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	local g2=Duel.GetMatchingGroup(cm.rmfilter2,tp,0,LOCATION_MZONE,nil,g1:GetFirst():GetAttribute())
	local gr=false
	if g1:GetFirst():IsLocation(LOCATION_GRAVE) then gr=true end
	g1:Merge(g2)
	if gr then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),tp,LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
	end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local tg=Group.FromCards(tc)
		if tc:IsFaceup() then
			local g=Duel.GetMatchingGroup(cm.rmfilter2,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
			tg:Merge(g)
		end
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end

--negate
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
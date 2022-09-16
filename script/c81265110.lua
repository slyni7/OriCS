--오덱시즈 카리
--카드군 번호: 0xc91
local m=81265110
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(0x02)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--유발 트리거
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end

--특수 소환
function cm.tfilter1(c)
	return c:IsAbleToRemove() and c:IsRace(RACE_THUNDER)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsLocation(0x10) and cm.tfilter1(chkc)
	end
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingTarget(cm.tfilter1,tp,0x10,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.tfilter1,tp,0x10,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.spfilter1(c,e,tp,att)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc91) and c:IsType(0x1)
	and not c:IsAttribute(att)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
	local g=Duel.GetMatchingGroup(cm.spfilter1,tp,0x01+0x02,0,nil,e,tp,tc:GetOriginalAttribute())
	if #g>0 and Duel.GetLocationCount(tp,0x04)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,0x01+0x02,0,1,1,nil,e,tp,tc:GetOriginalAttribute())
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end

--유발 트리거
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x20) and chkc:IsControler(tp) and chkc:IsAbleToDeck()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0x20,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0x20,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#g*300)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if ct>0 then
		Duel.Damage(1-tp,ct*300,REASON_EFFECT)
	end
end

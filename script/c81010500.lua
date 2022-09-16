--백랑 이누바시리
--카드군 번호: 0xca1
local m=81010500
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0x02+0x10)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--발동 제한
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(0x04)
	e2:SetTargetRange(0,1)
	e2:SetCondition(cm.cn2)
	e2:SetValue(cm.va2)
	c:RegisterEffect(e2)
	
	--제거
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetRange(0x04)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end

--특수 소환
function cm.cfil0(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsSetCard(0xca1) and c:IsType(0x1) and not c:IsCode(m)
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil0,tp,0x10,0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x10,0,2,2,nil)
	local tc=g:GetFirst()
	Duel.SendtoDeck(tc,nil,0,REASON_COST)
	if tc:IsExists(Card.IsLocation,1,nil,0x01) then Duel.ShuffleDeck(tp) end
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--발동 제한
function cm.cn2(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function cm.va2(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

--제거
function cm.nfil0(c)
	return (c:IsFaceup() or c:IsLocation(0x01)) and c:IsSetCard(0xca1)
end
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil0,1,nil)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsAbleToDeck()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,0x0c+0x10,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,0x0c+0x10,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end

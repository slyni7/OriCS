--백랑-쾌도
local m=81010340
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	
	--return to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--Ritual Spell Set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(0x02+0x04)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--return to hand
function cm.cfilter1(c)
	return c:IsReleasable() and c:IsRace(RACE_BEASTWARRIOR)
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfilter1,tp,0x02+0x04,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,0x02+0x04,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then 
		return chkc:IsLocation(0x04) and chkc:IsControler(1-tp) and chkc:IsAbleToHand()
	end
	if chk==0 then 
		return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsLocation(LOCATION_MZONE) and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--Ritual Spell Set
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.tfilter1(c,ft)
	return (c:IsAbleToHand() or (ft>0 and c:IsSSetable()))
	and c:IsSetCard(0xca1) and c:IsType(TYPE_RITUAL) and c:IsType(0x2)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(cm.tfilter1,tp,0x01,0,1,nil,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,0x01)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,0x08)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local g=Duel.SelectMatchingCard(tp,cm.tfilter1,tp,0x01,0,1,1,nil,ft)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end

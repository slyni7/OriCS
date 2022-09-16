--프로미스, Merry-Go-Round.
local m=112603273
local cm=_G["c"..m]
function cm.initial_effect(c)
	--beyond summon
	c:EnableReviveLimit()
	aux.AddBeyondProcedure(c,nil,">",aux.FilterBoolFunction(Card.IsSetCard,0xe9f),"A")
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg1)
	e1:SetOperation(cm.thop1)
	c:RegisterEffect(e1)
	--lv
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(m,1))
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_ONFIELD)
	e10:SetCountLimit(1)
	e10:SetTarget(cm.lvtg)
	e10:SetOperation(cm.lvop)
	c:RegisterEffect(e10)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,m+1)
	e4:SetTarget(cm.eqtg)
	e4:SetOperation(cm.eqop)
	c:RegisterEffect(e4)
end

cm.custom_type=CUSTOMTYPE_BEYOND

--search
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_BEYOND)
end
function cm.thfilter(c)
	return c:IsSetCard(0xe9f) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--lv
function cm.filter(c)
	return c:IsFaceup() and not c:IsLevel(7) and c:IsLevelAbove(1)
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(7)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end

--equip
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe9f)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not tc:IsControler(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(cm.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
--1과 i의 마녀(아트릭시아) 아트리스타 아트래터
local m=112604013
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.mfilter,2,2,cm.lcheck)
	c:EnableReviveLimit()
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e1:SetValue(112604004)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e0:SetValue(112604000)
	c:RegisterEffect(e0)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.thcon2)
	e4:SetTarget(cm.thtg2)
	e4:SetOperation(cm.thop2)
	c:RegisterEffect(e4)
	--ritual level
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_RITUAL_LEVEL)
	e11:SetValue(cm.val1)
	c:RegisterEffect(e11)
end

--ritual level
function cm.val1(e,c)
	local lv=e:GetHandler():GetLevel()
	local clv=c:GetLevel()
	return lv*65536+clv
end

--link summon
function cm.mfilter(c)
	return c:IsLevelAbove(0)
end
function cm.lcheck(g,lc)
	return g:GetClassCount(Card.GetLevel)==g:GetCount()
end

--search
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_RITUAL)
end
function cm.thfilter(c)
	return (c:IsCode(112604016) or c:IsCode(112604015)) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
		and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

--to hand
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)) and c:IsPreviousPosition(POS_FACEUP)
end
function cm.thfilter2(c)
	return c:IsCode(112604017) and c:IsAbleToHand()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

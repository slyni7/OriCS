--오덱시즈 이카즈치
--카드군 번호: 0xc91
local m=81265100
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc91),4,2,cm.xyzfil0,aux.Stringid(m,0),63,cm.xyzop)
	
	--덤핑
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--프리체인
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--엑시즈
function cm.xyzfil0(c,tp,xyzc)
	return c:IsFaceup() and c:IsSetCard(0xc91) and c:IsType(TYPE_ORDER,xyzc,SUMMON_TYPE_XYZ,tp)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,m)==0
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	return true
end

--덤핑
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x01)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0x01,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsSetCard(0xc91) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT,true)
	end
end

--프리체인
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	local rt=Duel.GetTargetCount(Card.IsFaceup,tp,0,0x0c,nil)
	local ct=c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	e:SetLabel(ct)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,0,0x0c,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,0x0c,e:GetLabel(),e:GetLabel(),nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,e:GetLabel(),0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end

--운명의 좌 「유구」
local m=99970246
local cm=_G["c"..m]
function cm.initial_effect(c)

	--링크 소환
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,2,nil,cm.spcheck)
	
	--가챠는 나쁜 문명!
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--회수
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)

	--레벨 증가
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.indtg)
	c:RegisterEffect(e3)
	
end

--가챠는 좋은 문명!
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)==0
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
	Duel.Hint(HINT_CARD,0,m)
	atk=YuL.random(1500,4000)
	Duel.Hint(HINT_NUMBER,tp,atk)
	Duel.Hint(HINT_NUMBER,1-tp,atk)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(atk)
	c:RegisterEffect(e1)
end

--링크 소환
function cm.matfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0xd3b,lc,sumtype,tp) and not c:IsType(TYPE_XYZ+TYPE_LINK)
end
function cm.spcheck(g,lc,tp)
	return g:GetClassCount(Card.GetLevel,lc,SUMMON_TYPE_LINK,tp)>1
end

--회수
function cm.thfilter(c)
	return c:IsSetCard(0xd3b) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--레벨 증가
function cm.indtg(e,c)
	return c:IsSetCard(0xd3b) and e:GetHandler():GetLinkedGroup():IsContains(c)
end

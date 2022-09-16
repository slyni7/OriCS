--드라코센드 카프리콘
function c95480506.initial_effect(c)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,95480506)
	e1:SetValue(c95480506.matval)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37119142,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,95480594)
	e2:SetCondition(c95480506.thcon)
	e2:SetTarget(c95480506.thtg)
	e2:SetOperation(c95480506.thop)
	c:RegisterEffect(e2)
end

function c95480506.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_WYRM)
end
function c95480506.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(95480506)
end
function c95480506.matval(e,lc,mg,c,tp)
	if not lc:IsSetCard(0xd5b) then return false,nil end
	return true,not mg or mg:IsExists(c95480506.mfilter,1,nil) and not mg:IsExists(c95480506.exmfilter,1,nil)
end

function c95480506.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(0)
	if c:IsPreviousLocation(LOCATION_ONFIELD) then e:SetLabel(1) end
	return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and r==REASON_LINK
end
function c95480506.thfilter(c)
	return c:IsSetCard(0xd5b) and not c:IsCode(95480506) and c:IsAbleToHand()
end
function c95480506.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c95480506.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95480506.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c95480506.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c95480506.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end


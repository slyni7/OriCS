--아니마기아스 레조넌스
function c95481015.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c95481015.val)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SYNCHRO))
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2819435,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,95481015)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c95481015.thcon)
	e2:SetTarget(c95481015.thtg)
	e2:SetOperation(c95481015.thop)
	c:RegisterEffect(e2)
end
function c95481015.val(e,c)
	local lv=c:GetMaterial():GetSum(Card.GetLevel)
	return lv*100
end
function c95481015.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:GetSummonPlayer()==tp and tc:IsFaceup() and tc:IsSetCard(0xd5e)
end
function c95481015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c95481015.mfilter(c)
	return c:IsFaceup() and c:IsCode(95481011)
end
function c95481015.filter(c,e,tp,chk)
	return c:IsSetCard(0xd5e) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToHand() or chk and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP))
end
function c95481015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481015.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c95481015.thop(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c95481015.mfilter,tp,LOCATION_FZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95481015.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,b)
	local tc=g:GetFirst()
	if tc then
		if b and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
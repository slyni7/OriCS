--드라코센드 에퀴녹스
function c95480516.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,95480516)
	e1:SetTarget(c95480516.target)
	e1:SetOperation(c95480516.operation)
	c:RegisterEffect(e1)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,95480584)
	e3:SetCondition(c95480516.thcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c95480516.thtg)
	e3:SetOperation(c95480516.thop)
	c:RegisterEffect(e3)
end
function c95480516.filter(c,e,tp)
	return c:IsFaceup() and (c:IsRace(RACE_WYRM) or c:IsSetCard(0xd5f)) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c95480516.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetCode())
end
function c95480516.spfilter(c,e,tp,code)
	return (c:IsRace(RACE_WYRM) or c:IsSetCard(0xd5f)) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and c:IsLinkState()
end
function c95480516.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c95480516.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c95480516.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectTarget(tp,c95480516.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c95480516.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95480516.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc:GetCode())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c95480516.thcfilter(c,tp)
	return c:IsType(TYPE_LINK) and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c95480516.thcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and eg:IsExists(c95480516.thcfilter,1,nil,tp)
end
function c95480516.thfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0xd5b) or c:IsSetCard(0xd5f))  and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c95480516.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480516.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c95480516.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c95480516.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		if sc then
			if sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and (not sc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
			end
		end
	end
end

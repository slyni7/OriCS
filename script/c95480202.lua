--단원2 세토
function c95480202.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd4c),4,3)
	c:EnableReviveLimit()
	--banish extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95474755,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,95480202)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c95480202.excost)
	e1:SetTarget(c95480202.extg)
	e1:SetOperation(c95480202.exop)
	c:RegisterEffect(e1,false,1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,95480298)
	e2:SetCondition(c95480202.con)
	e2:SetTarget(c95480202.thtg)
	e2:SetOperation(c95480202.thop)
	c:RegisterEffect(e2)
end
function c95480202.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c95480202.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c95480202.exop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
	if Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)>0 then
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_DECK+LOCATION_EXTRA)
		local tg=g2:Filter(Card.IsCode,nil,sg:GetFirst():GetCode())
		if tg:GetCount()>0 then
			Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c95480202.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c95480202.filter(c,e,tp,ft)
	return c:IsSetCard(0xd4c) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c95480202.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480202.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ft) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
end
function c95480202.thop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c95480202.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end


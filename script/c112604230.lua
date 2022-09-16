--Welcome to Neverwor!D
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.tar1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField() and chkc:IsFaceup() and chkc~=c
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
end
function s.nfil111(c)
	return c:IsFaceup() and c:IsCode(112601198)
end
function s.nfil112(c)
	return c:IsFaceup() and c:IsSetCard(0xe90) and c:IsType(TYPE_MONSTER)
end
function s.tfil11(c)
	return c:IsAbleToHand() and c:IsSetCard(0xe90) and c:IsType(TYPE_SPELL) and not c:IsCode(112604230)
end
function s.nfil121(c)
	return c:IsFaceup() and c:IsSetCard(0xe70)
end
function s.nfil122(c)
	return c:IsFaceup() and c:IsSetCard(0xe72) and c:IsType(TYPE_MONSTER)
end
function s.tfil12(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xe70)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then
		return
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(112601198)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local g1=Duel.GetMatchingGroup(s.tfil11,tp,LOCATION_DECK,0,nil)
	if (Duel.IsExistingMatchingCard(s.nfil111,tp,LOCATION_ONFIELD,0,1,nil)
		or Duel.IsExistingMatchingCard(s.nfil112,tp,LOCATION_MZONE,0,1,nil))
		and #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local sg1=g1:Select(tp,1,1,nil)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
	local g2=Duel.GetMatchingGroup(s.tfil12,tp,LOCATION_DECK,0,nil)
	if (Duel.IsExistingMatchingCard(s.nfil121,tp,LOCATION_ONFIELD,0,1,nil)
		or Duel.IsExistingMatchingCard(s.nfil122,tp,LOCATION_MZONE,0,1,nil))
		and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local sg2=g2:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg2,REASON_EFFECT)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetCondition(s.ocon12)
		e2:SetOperation(s.oop12)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.ocon12(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.oofil12(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xe72)
end
function s.oop12(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local g=Duel.SelectMatchingCard(tp,s.oofil12,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
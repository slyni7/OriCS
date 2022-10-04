--카노네(ONESELF) 유니버스 에덴
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),2,nil,s.matcheck)
	--Add 1 "Salamangreat Sanctuary" to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e1:SetCondition(s.rmcon)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.indtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot be banished
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetTarget(s.rmlimit)
	c:RegisterEffect(e4)
end
function s.indtg(e,c)
	local oc=e:GetHandler()
	return c==oc or oc:GetLinkedGroup():IsContains(c)
end
function s.rmlimit(e,c,tp,r)
	local oc=e:GetHandler()
	return (c==oc or oc:GetLinkedGroup():IsContains(c)) and r==REASON_EFFECT
end

function s.thfilter(c)
	return (c:IsSetCard(0xe90) or c:IsSetCard(0xe72) or c:IsSetCard(0xe92) or c:IsSetCard(0xe78) or c:IsSetCard(0xe9f)
		 or c:IsSetCard(0xe74) or c:IsSetCard(0xe7a))
		and c:IsAbleToHand()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.mfilter(c,lc,sumtype,tp)
	return c:IsSummonCode(lc,sumtype,tp,112604289)
		or c:IsSetCard(0xe90,lc,sumtype,tp)
		or c:IsSetCard(0xe72,lc,sumtype,tp)
		or c:IsSetCard(0xe92,lc,sumtype,tp)
		or c:IsSetCard(0xe78,lc,sumtype,tp)
		or c:IsSetCard(0xe9f,lc,sumtype,tp)
		or c:IsSetCard(0xe74,lc,sumtype,tp)
		or c:IsSetCard(0xe7a,lc,sumtype,tp)
end
function s.matcheck(g,lc,sumtype,tp)
	return g:IsExists(s.mfilter,1,nil,lc,sumtype,tp)
end


function s.rmfilter(c)
	return (c:IsSetCard(0xe90) or c:IsSetCard(0xe72) or c:IsSetCard(0xe92) or c:IsSetCard(0xe78) or c:IsSetCard(0xe9f)
		 or c:IsSetCard(0xe74) or c:IsSetCard(0xe7a))
		and c:IsFaceup() and c:IsMonster()
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_MZONE,0,1,nil)
end
--remove
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
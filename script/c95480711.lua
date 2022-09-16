--경탄의 묘지
function c95480711.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70109009,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,95480711)
	e2:SetCondition(c95480711.con)
	e2:SetTarget(c95480711.tg)
	e2:SetOperation(c95480711.op)
	c:RegisterEffect(e2)
	--tribute summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95480711,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,95480789)
	e3:SetTarget(c95480711.sumtg)
	e3:SetOperation(c95480711.sumop)
	c:RegisterEffect(e3)
end

function c95480711.cfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c95480711.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c95480711.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c95480711.filter(c)
	return c:IsSetCard(0xd4a) and c:IsAbleToHand() and not c:IsCode(95480711)
end
function c95480711.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480711.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95480711.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c95480711.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c95480711.sumfilter(c)
	return c:IsSetCard(0xd4a) and c:IsSummonable(true,nil,1) and c:IsLevelAbove(5)
end
function c95480711.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480711.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c95480711.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c95480711.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1)
	end
end
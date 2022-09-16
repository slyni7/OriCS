--드라코센드 아리에스
function c95480501.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78080961,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c95480501.thtg)
	e1:SetOperation(c95480501.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78080961,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,95480501)
	e3:SetCondition(c95480501.spcon)
	e3:SetCost(c95480501.spcost)
	e3:SetTarget(c95480501.sptg)
	e3:SetOperation(c95480501.spop)
	c:RegisterEffect(e3)
end

function c95480501.thfilter(c)
	return c:IsSetCard(0xd5b) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsCode(95480501)
end
function c95480501.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480501.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95480501.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95480501.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c95480501.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c95480501.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c95480501.cfilter(c)
	return c:IsSetCard(0xd5b) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsType(TYPE_MONSTER)
end
function c95480501.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c95480501.cfilter,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,c95480501.cfilter,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c95480501.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c95480501.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
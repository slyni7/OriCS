--파라바이오트 프로스펙트
function c95481206.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c95481206.tg)
	e1:SetValue(c95481206.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c95481206.defval)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(41685633,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c95481206.tdcon)
	e3:SetTarget(c95481206.tdtg)
	e3:SetOperation(c95481206.tdop)
	c:RegisterEffect(e3)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9659580,2))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(c95481206.thtg)
	e5:SetOperation(c95481206.thop)
	c:RegisterEffect(e5)
end

function c95481206.atkval(e,c)
	return c:GetBaseAttack()/4
end
function c95481206.defval(e,c)
	return c:GetBaseDefense()/4
end
function c95481206.tg(e,c)
	return c:IsSetCard(0xd47)
end

function c95481206.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0xd47)
end
function c95481206.filter(c,e,tp)
	return c:IsSetCard(0xd47) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95481206.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c95481206.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c95481206.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95481206.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c95481206.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end
function c95481206.cfilter(c)
	return c:IsSetCard(0xd47) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(95481206)
end
function c95481206.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(95481201,0))
	local tg=Duel.GetMatchingGroup(c95481206.cfilter,tp,0,LOCATION_DECK,nil)
	if tg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOHAND)
	local g=tg:Select(1-tp,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,1-tp,REASON_EFFECT)==0 then
			Duel.ShuffleDeck(1-tp)
		end
	end
end

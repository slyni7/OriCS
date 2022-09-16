--리리컬 BLAST(레이) - 리리시아
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(s.target2)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe79) and c:GetLevel()==0
end
function s.filter3(c)
	return c:IsFaceup() and c:IsCode(112604200)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain(true)==0 and (Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
		or Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_ONFIELD,0,1,nil))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,#eg,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end
function s.filter1(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,lv,e,tp) and c:IsSetCard(0xe79)
end
function s.filter2(c,lv,e,tp)
	return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xe79)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc:GetLevel(),e,tp)
	local sc=g:GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) then
	end
end
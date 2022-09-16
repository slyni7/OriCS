--신주곡:라이트닝
local m=112604232
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,{m,1},EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,{m,2},EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(cm.descon)
	e2:SetTarget(cm.tar2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return ((c:IsLocation(LOCATION_DECK) and (c:IsSetCard(0xe72) or c:IsSetCard(0xe70)) and not c:IsCode(m))
		or (c:IsSetCard(0xe90) and c:IsMonster()))
		and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xe70,0x21,0,0,7,RACE_CYBERSE,ATTRIBUTE_DARK,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)==0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xe70,0x21,0,0,7,RACE_CYBERSE,ATTRIBUTE_DARK,1-tp)) then return end
	c:AddMonsterAttribute(TYPE_EFFECT)
	Duel.SpecialSummonStep(c,0,tp,1-tp,true,false,POS_FACEUP)
	c:AddMonsterAttributeComplete()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(112601198)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.ocon22)
	e2:SetOperation(cm.oop22)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)	
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetCondition(cm.ocon22)
	e2:SetOperation(cm.oop22)
	c:RegisterEffect(e2)
	--damage
	Duel.SpecialSummonComplete()
end
function cm.onfil22(c,tp)
	return c:IsControler(1-tp)
end
function cm.ocon22(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.onfil22,1,nil,tp)
end
function cm.oop22(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
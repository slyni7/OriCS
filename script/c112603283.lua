--에클레어, Merry-Go-Round.
local m=112603283
local cm=_G["c"..m]
function cm.initial_effect(c)
	--module summon
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),nil,1,99,nil)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--level change
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCountLimit(1,m+1)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(cm.lvtar)
	e5:SetOperation(cm.lvop)
	c:RegisterEffect(e5)
	--atk
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetDescription(aux.Stringid(m,2))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,m+1)
	e6:SetTarget(cm.atktg)
	e6:SetOperation(cm.atkop)
	c:RegisterEffect(e6)
	--atk
	local e60=Effect.CreateEffect(c)
	e60:SetCategory(CATEGORY_ATKCHANGE)
	e60:SetDescription(aux.Stringid(m,3))
	e60:SetType(EFFECT_TYPE_IGNITION)
	e60:SetRange(LOCATION_MZONE)
	e60:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e60:SetCountLimit(1,m+1)
	e60:SetTarget(cm.deftg)
	e60:SetOperation(cm.defop)
	c:RegisterEffect(e60)
end

--special summon
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_MODULE)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xe9f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--level change
function cm.lvfilter(c)
	return c:GetLevel()>0 and not c:IsCode(m)
end
function cm.lvtar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(cm.lvfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.lvfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

--atk
function cm.atkfilter(c,atk)
	return c:IsFaceup() and not c:IsAttack(atk) and not c:IsCode(m)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(tp) and chkc~=c and c17086528.atkfilter(chkc,atk) end
	if chk==0 then return Duel.IsExistingTarget(cm.atkfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,c,atk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.atkfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,c,atk)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

--def
function cm.deffilter(c,def)
	return c:IsFaceup() and not c:IsDefense(def) and not c:IsCode(m)
end
function cm.deftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local def=c:GetDefense()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(tp) and chkc~=c and cm.deffilter(chkc,def) end
	if chk==0 then return Duel.IsExistingTarget(cm.deffilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,c,def) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.deffilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,c,def)
end
function cm.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local def=tc:GetDefense()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetValue(def)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

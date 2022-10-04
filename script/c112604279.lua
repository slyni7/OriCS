--클라이드(ONESELF), Merry-Go-Round.
local s,id=GetID()
function s.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(s.condition1)
	e3:SetCost(s.cost1)
	e3:SetTarget(s.target1)
	e3:SetOperation(s.activate1)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(s.condition2)
	e3:SetTarget(s.target1)
	e3:SetOperation(s.activate1)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.sumtg)
	e1:SetOperation(s.sumop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCountLimit(1,{id,2},EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.activate3)
	c:RegisterEffect(e3)
end

function s.nfil1(c)
	return c:IsSetCard(0xe75) and c:IsLevelBelow(4) and c:IsFaceup()
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.nfil1,tp,LOCATION_MZONE,0,1,nil)
end
function s.nfil2(c)
	return c:IsSetCard(0xe9f) and c:IsLevelBelow(7) and c:IsFaceup()
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.nfil2,tp,LOCATION_MZONE,0,1,nil)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not c:IsPublic()
	end
	Duel.ConfirmCards(1-tp,c)
end
function s.filter3(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsSetCard(0xe9f) and c:IsCustomType(CUSTOMTYPE_BEYOND)
		and c:IsLevelBelow(7)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local gchk=c:IsLocation(LOCATION_GRAVE)
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and (not gchk or Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_EXTRA,0,1,nil))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gchk=c:IsLocation(LOCATION_GRAVE)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and gchk then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_EXTRA,0,1,1,nil)
		if #sg>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function s.filter(c,e,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsSetCard(0xe75) or c:IsCustomType(CUSTOMTYPE_BEYOND))
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		if tc:IsSetCard(0xe75) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
	Duel.SpecialSummonComplete()
end

function s.filter3(c)
	return (c:IsSetCard(0xe70) or (c:IsType(TYPE_EQUIP) and c:IsSetCard(0xe9f)))
		and c:IsAbleToHand()
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter3,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.activate3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
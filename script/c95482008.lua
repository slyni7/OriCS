--창조의 비전술
function c95482008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95482008+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c95482008.cost)
	e1:SetTarget(c95482008.target)
	e1:SetOperation(c95482008.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(95482008,ACTIVITY_CHAIN,c95482008.chainfilter)
end
function c95482008.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0xd40) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY)
end
function c95482008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetCustomActivityCount(95482008,tp,ACTIVITY_CHAIN)<3 end
end
function c95482008.filter(c)
	return c:IsSetCard(0xd40) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c95482008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95482008.filter,tp,LOCATION_DECK,0,1,nil) end
	local ct=Duel.GetCustomActivityCount(95482008,tp,ACTIVITY_CHAIN)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		ct=ct-1
	end
	local cat=CATEGORY_TOHAND+CATEGORY_SEARCH
	if ct>=2 then
		cat=cat+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN
	end
	e:SetCategory(cat)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95482008.sfilter(c)
	return c:IsSetCard(0xd40) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c95482008.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95482008.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local ct=Duel.GetCustomActivityCount(95482008,tp,ACTIVITY_CHAIN)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		ct=ct-1
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g2=Duel.GetMatchingGroup(c95482008.sfilter,tp,LOCATION_DECK,0,nil)
	if ct>=1 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95482008,1)) then
		Duel.BreakEffect()
		local dg=Duel.SelectMatchingCard(tp,c95482008.sfilter,tp,LOCATION_DECK,0,1,1,nil)
		if dg:GetCount()>0 then
			Duel.SSet(tp,dg:GetFirst())
		end
	end
	if ct>=2 and ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,95482000,0,0x4011,3000,3000,10,RACE_PLANT,ATTRIBUTE_EARTH,POS_FACEUP) and Duel.SelectYesNo(tp,aux.Stringid(95482008,2)) then
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,95482000)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e1:SetValue(c95482008.atlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		token:RegisterEffect(e3)
		end
	end
end
function c95482008.atlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end


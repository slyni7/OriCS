--크로노이드 조엘
function c95481816.initial_effect(c)
	aux.EnableUnionAttribute(c,c95481816.ufil1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10182251,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,95481816)
	e1:SetTarget(c95481816.sptg)
	e1:SetOperation(c95481816.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetDescription(aux.Stringid(95481801,0))
	e2:SetTarget(c95481816.tar2)
	e2:SetOperation(c95481816.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(95481801,1))
	e3:SetTarget(c95481816.tar3)
	e3:SetOperation(c95481816.op3)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(c95481816.immcon)
	e4:SetValue(c95481816.efilter)
	c:RegisterEffect(e4)
end
function c95481816.ufil1(e,c)
	return c:IsRace(RACE_PSYCHO) or e:GetHandler():GetEquipTarget()==c
end
function c95481816.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_UNION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetEquipTarget()~=nil
end
function c95481816.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c95481816.spfilter(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c95481816.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95481816.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c95481816.thfilter(c)
	return c:IsSetCard(0xd54) and not c:IsCode(95481816) and c:IsAbleToHand()
end
function c95481816.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		local g=Group.FromCards(c,tc)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			if Duel.IsExistingMatchingCard(c95481816.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(95481816,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,c95481816.thfilter,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end

function c95481816.immcon(e)
	local ec=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker()==ec or Duel.GetAttackTarget()==ec
end
function c95481816.efilter(e,te)
	return not te:GetOwner():IsSetCard(0xd54)
end

function c95481816.tfil3(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and ct2==0
end
function c95481816.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c95481816.tfil3(chkc)
	end
	if chk==0 then
		return c:GetFlagEffect(95481816)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingTarget(c95481816.tfil3,tp,LOCATION_MZONE,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c95481816.tfil3,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(95481816,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c95481816.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	if not tc:IsRelateToEffect(e) or not c95481816.tfil3(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then
		return
	end
	aux.SetUnionState(c)
end
function c95481816.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(95481816)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(95481816,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c95481816.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
--몽시공의 여행자
--카드군 번호: 0xc97
function c81261020.initial_effect(c)

	--소재시 효과
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCountLimit(1,81261020)
	e1:SetCondition(c81261020.cn1)
	e1:SetCost(c81261020.co1)
	e1:SetTarget(c81261020.tg1)
	e1:SetOperation(c81261020.op1)
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c81261020.co2)
	e2:SetTarget(c81261020.tg2)
	e2:SetOperation(c81261020.op2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(81261020,ACTIVITY_SPSUMMON,c81261020.ctfil)
end

--소환 제약
function c81261020.ctfil(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or c:IsType(TYPE_ORDER)
end

--소재시 효과
function c81261020.cn1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_ORDER
end
function c81261020.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetCustomActivityCount(81261020,tp,ACTIVITY_SPSUMMON)==0
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81261020.splim)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81261020.splim(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_ORDER) and c:IsLocation(LOCATION_EXTRA)
end
function c81261020.tfil0(c)
	return c:IsAbleToRemove() and c:IsSetCard(0xc97) and not c:IsCode(81261020)
end
function c81261020.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81261020.tfil0,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x01)
end
function c81261020.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81261020.tfil0,tp,0x01,0,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

--특수 소환
function c81261020.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c81261020.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetCustomActivityCount(81261020,tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingMatchingCard(c81261020.cfil0,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81261020.cfil0,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81261020.splim)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81261020.spfil0(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xc97) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	and c:IsLevelBelow(4)
end
function c81261020.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c81261020.spfil0,tp,0x20,0,1,nil,e,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81261020.spfil0,tp,0x20,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetChainLimit(c81261020.chlim)
end
function c81261020.chlim(e,rp,tp)
	local c=e:GetHandler()
	return tp==rp or (not c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_HAND) ) 
end
function c81261020.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or Duel.IsPlayerAffectedByEffect(tp,59822133)
	or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then
		return
	end
	if not tc:IsRelateToEffect(e) then
		return
	end
	local g=Group.FromCards(c,tc)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end

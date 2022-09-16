--몽시공의 교수
--카드군 번호: 0xc97
function c81261010.initial_effect(c)

	--소재시 효과
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCountLimit(1,81261010)
	e1:SetCondition(c81261010.cn1)
	e1:SetCost(c81261010.co1)
	e1:SetTarget(c81261010.tg1)
	e1:SetOperation(c81261010.op1)
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c81261010.cn2)
	e2:SetCost(c81261010.co1)
	e2:SetTarget(c81261010.tg2)
	e2:SetOperation(c81261010.op2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(81261010,ACTIVITY_SPSUMMON,c81261010.ctfil)
end

--소환 제약
function c81261010.ctfil(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or c:IsType(TYPE_ORDER)
end

--소재시 효과
function c81261010.cn1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_ORDER
end
function c81261010.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetCustomActivityCount(81261010,tp,ACTIVITY_SPSUMMON)==0
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81261010.splim)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81261010.splim(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_ORDER) and c:IsLocation(LOCATION_EXTRA)
end
function c81261010.tfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc97) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81261010.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81261010.tfil0,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end
function c81261010.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81261010.tfil0,tp,0x01,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--특수 소환
function c81261010.cn2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c81261010.spfil0(c,e,tp)
	return c:IsSetCard(0xc97) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81261010.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c81261010.spfil0,tp,0x01,0,1,nil,e,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0x01+0x02)
	Duel.SetChainLimit(c81261010.chlim)
end
function c81261010.chlim(e,rp,tp)
	local c=e:GetHandler()
	return tp==rp or (not c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_HAND) ) 
end
function c81261010.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.IsPlayerAffectedByEffect(tp,59822133)
	or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81261010.spfil0,tp,0x01,0,1,1,nil,e,tp)
	if #g>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--드라코센드 제미니
function c95480503.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46659709,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c95480503.spcost)
	e1:SetTarget(c95480503.sptg)
	e1:SetOperation(c95480503.spop)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9929398,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95480597)
	e2:SetCondition(c95480503.tkncon)
	e2:SetCost(c95480503.tkncost)
	e2:SetTarget(c95480503.tkntg)
	e2:SetOperation(c95480503.tknop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(95480503,ACTIVITY_SPSUMMON,c95480503.counterfilter)
end
function c95480503.cfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAbleToGraveAsCost()
end
function c95480503.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480503.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c95480503.cfilter,1,1,REASON_COST,e:GetHandler())
end
function c95480503.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c95480503.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c95480503.counterfilter(c)
	return c:IsRace(RACE_WYRM)
end
function c95480503.tkncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLinkState()
end
function c95480503.tkncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.GetCustomActivityCount(95480503,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Release(e:GetHandler(),REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c95480503.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c95480503.splimit(e,c)
	return c:GetRace()~=RACE_WYRM
end
function c95480503.tkntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,95480597,0xd5b,0x4011,300,300,1,RACE_WYRM,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c95480503.tknop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,95480597,0xd5b,0x4011,300,300,1,RACE_WYRM,ATTRIBUTE_WIND) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,95480597)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end

--몽시공 - 몽환전설
--카드군 번호: 0xc97
function c81261040.initial_effect(c)

	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0x10)
	e1:SetCountLimit(1,81261040)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c81261040.tg1)
	e1:SetOperation(c81261040.op1)
	c:RegisterEffect(e1)
	
	--발동시 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c81261040.co2)
	e2:SetTarget(c81261040.tg2)
	e2:SetOperation(c81261040.op2)
	c:RegisterEffect(e2)
end

--서치
function c81261040.tfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc97) and c:IsType(TYPE_MONSTER)
end
function c81261040.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81261040.tfil0,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x02)
end
function c81261040.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c81261040.tfil0,tp,0x01,0,1,1,nil)
	if #g1==0 then
		return
	end
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0x02,0,nil)
	local sg=g2:Select(tp,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end

--발동시 효과
function c81261040.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc97)
end
function c81261040.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81261040.cfil0,tp,0x02+0x10,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81261040.cfil0,tp,0x02+0x10,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81261040.spfil0(c,e,tp)
	return c:IsSetCard(0xc97) and c:IsLevelBelow(4) and ( c:IsLocation(0x01) or c:IsFaceup() )
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c81261040.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81261040.spfil0,tp,0x01+0x20,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01+0x20)
end
function c81261040.ordfil0(c)
	return (c:IsSpecialSummonable(SUMMON_TYPE_ORDER) 
	or c:IsSpecialSummonable(SUMMON_TYPE_ORDER_L) or c:IsSpecialSummonable(SUMMON_TYPE_ORDER_R))
	and c:IsRace(RACE_CYBERSE) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c81261040.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81261040.spfil0,tp,0x01+0x20,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local mg=Duel.GetMatchingGroup(c81261040.ordfil0,tp,0x40,0,nil)
		if #mg>0 and Duel.SelectYesNo(tp,aux.Stringid(81261040,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=mg:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if not tc then
				return
			end
			Duel.SpecialSummonRule(tp,tc,tc:GetSummonType())
		end
	end
end

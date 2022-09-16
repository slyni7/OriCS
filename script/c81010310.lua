--야조백랑

function c81010310.initial_effect(c)

	--Rank up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81010310+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81010310.rucn)
	e1:SetTarget(c81010310.rutg)
	e1:SetOperation(c81010310.ruop)
	c:RegisterEffect(e1)
	
end

--Rank up
function c81010310.rucn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end

function c81010310.rutgfilter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xca1)
	   and Duel.IsExistingMatchingCard(c81010310.rutgfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1)
end
function c81010310.rutgfilter2(c,e,tp,mc,rk)
	return ( c:GetRank()==rk or c:GetRank()==rk+1 or c:GetRank()==rk+2 )
	   and c:IsSetCard(0xca1)
	   and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true)
	   and mc:IsCanBeXyzMaterial(c)
end
function c81010310.rutg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_MZONE)
			and c81010310.rutgfilter1(chkc,e,tp)
			end
	if chk==0 then return
				Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingTarget(c81010310.rutgfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81010310.rutgfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c81010310.ruop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81010310.rutgfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

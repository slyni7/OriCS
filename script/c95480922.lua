--영매술 - 「전생」
function c95480922.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480922+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95480922.tar1)
	e1:SetOperation(c95480922.op1)
	c:RegisterEffect(e1)
end
function c95480922.tfil11(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xd42) and c:IsReleasable()
end
function c95480922.tfil12(c,e,tp,mg)
	if c:GetType()&0x81~=0x81 or not c:IsSetCard(0xd42) then
		return false
	end
	local m=mg:Clone()
	m:RemoveCard(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,c:GetLevel(),"Equal")
	local res=m:CheckSubGroup(c95480922.tfun1,1,c:GetLevel(),e,tp,c)
	aux.GCheckAdditional=nil
	return res
end
function c95480922.tfun1(sg,e,tp,rc)
	return sg:CheckWithSumEqual(c95480922.tfun2,rc:GetLevel(),#sg,#sg)
		and ((rc:IsLocation(LOCATION_EXTRA) and rc:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,sg,rc)>0) or (not rc:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp,sg)>0))
end
function c95480922.tfun2(c)
	return c:GetLeftScale()<<16+c:GetRightScale()
end
function c95480922.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c95480922.tfil11,tp,LOCATION_MZONE+LOCATION_PZONE,0,nil)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c95480922.tfil12,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c95480922.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c95480922.tfil11,tp,LOCATION_MZONE+LOCATION_PZONE,0,nil)
	local g=Duel.SelectMatchingCard(tp,c95480922.tfil12,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	local tc=g:GetFirst()
	if tc then
		mg:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,c95480922.tfun1,false,1,tc:GetLevel(),e,tp,tc)
		aux.GCheckAdditional=nil
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoExtraP(mat2,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
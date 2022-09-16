--영매술 - 「현현」
function c95480906.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480906+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95480906.tar1)
	e1:SetOperation(c95480906.op1)
	c:RegisterEffect(e1)
end
function c95480906.tfil11(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xd42)
end
function c95480906.tfil12(c,e,tp,mg)
	if c:GetType()&0x81~=0x81 or not c:IsSetCard(0xd42) then
		return false
	end
	local m=mg:Clone()
	m:RemoveCard(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,c:GetLevel(),"Equal")
	local res=m:CheckSubGroup(c95480906.tfun1,1,c:GetLevel(),e,tp,c)
	aux.GCheckAdditional=nil
	return res
end
function c95480906.tfun1(sg,e,tp,rc)
	return sg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),#sg,#sg,rc)
		and ((rc:IsLocation(LOCATION_EXTRA) and rc:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,sg,rc)>0) or (not rc:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp,sg)>0))
		and sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<2
end
function c95480906.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetRitualMaterial(tp)
	local exg=Duel.GetMatchingGroup(c95480906.tfil11,tp,LOCATION_DECK,0,nil)
	mg:Merge(exg)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c95480906.tfil12,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c95480906.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	local exg=Duel.GetMatchingGroup(c95480906.tfil11,tp,LOCATION_DECK,0,nil)
	mg:Merge(exg)
	local g=Duel.SelectMatchingCard(tp,c95480906.tfil12,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	local tc=g:GetFirst()
	if tc then
		mg:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,c95480906.tfun1,false,1,tc:GetLevel(),e,tp,tc)
		aux.GCheckAdditional=nil
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoExtraP(mat2,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		local fid=e:GetHandler():GetFieldID()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c95480906.thcon)
		e1:SetOperation(c95480906.thop)
		tc:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
	end
end
function c95480906.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c95480906.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
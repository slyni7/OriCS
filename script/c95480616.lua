--이레귤러: 오버 페이즈
function c95480616.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95481616+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95480616.target)
	e1:SetOperation(c95480616.activate)
	c:RegisterEffect(e1)
end
function c95480616.spfilter1(c,e,tp)
	return c:IsSetCard(0xd57) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c95480616.fselect(g,tp)
	return Duel.IsExistingMatchingCard(c95480616.synfilter,tp,LOCATION_EXTRA,0,1,nil,g) and aux.dncheck(g)
end
function c95480616.synfilter(c,g)
	return c:IsSetCard(0xd57) and c:IsSynchroSummonable(nil,g,g:GetCount()-1,g:GetCount()-1)
end
function c95480616.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),3)
	local g=Duel.GetMatchingGroup(c95480616.spfilter1,tp,LOCATION_REMOVED,0,nil,e,tp)
	local chkg=g:CheckSubGroup(c95480616.fselect,1,ft,tp)
	if chk==0 then return ft>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and chkg end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c95480616.fselect,false,1,ft,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c95480616.spfilter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480616.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c95480616.spfilter2,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local og=Duel.GetOperatedGroup()
	Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
	if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<g:GetCount() then return end
	local tg=Duel.GetMatchingGroup(c95480616.synfilter,tp,LOCATION_EXTRA,0,nil,og)
	if og:GetCount()==g:GetCount() and tg:GetCount()>0 then
		local tc=og:GetFirst()
		while tc do
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			e3:SetValue(LOCATION_DECKBOT)
			tc:RegisterEffect(e3)
			tc=og:GetNext()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=tg:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,rg:GetFirst(),nil,og,og:GetCount()-1,og:GetCount()-1)
	end
end


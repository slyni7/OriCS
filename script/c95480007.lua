--아카샤의 연대기
function c95480007.initial_effect(c)
	--syn
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95480007,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480007+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95480007.tg1)
	e1:SetOperation(c95480007.act1)
	c:RegisterEffect(e1)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95480007,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,95480007+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c95480007.tg2)
	e2:SetOperation(c95480007.act2)
	c:RegisterEffect(e2)
	--fusion
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95480007,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,11827244+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c95480007.target)
	e3:SetOperation(c95480007.activate)
	c:RegisterEffect(e3)
end

function c95480007.spfilter1(c,e,tp)
	return c:IsLevel(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function c95480007.fselect1(g,tp)
	return Duel.IsExistingMatchingCard(c95480007.synfilter,tp,LOCATION_EXTRA,0,1,nil,g) and aux.dncheck(g)
end
function c95480007.synfilter(c,g)
	return c:IsSetCard(0xb8) and c:IsSynchroSummonable(nil,g,g:GetCount()-1,g:GetCount()-1)
end
function c95480007.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
	local g=Duel.GetMatchingGroup(c95480007.spfilter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	local b1=g:CheckSubGroup(c95480007.fselect1,1,ft,tp)
	if chk==0 then return ft>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and (b1 or b2) end
	if b1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=g:SelectSubGroup(tp,c95480007.fselect1,false,1,ft,tp)
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c95480007.spfilterx(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480007.act1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c95480007.spfilterx,nil,e,tp)
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
	local tg=Duel.GetMatchingGroup(c95480007.synfilter,tp,LOCATION_EXTRA,0,nil,og)
	if og:GetCount()==g:GetCount() and tg:GetCount()>0 then
		local tc=og:GetFirst()
		while tc do
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			e3:SetValue(LOCATION_REMOVED)
			tc:RegisterEffect(e3)
			tc=og:GetNext()
		end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rg=tg:Select(tp,1,1,nil)
	Duel.SynchroSummon(tp,rg:GetFirst(),nil,og,og:GetCount()-1,og:GetCount()-1)
	end
end

function c95480007.spfilter2(c,e,tp)
	return c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function c95480007.fselect2(g,tp)
	return Duel.IsExistingMatchingCard(c95480007.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g) and aux.dncheck(g)
end
function c95480007.xyzfilter(c,g)
	return c:IsSetCard(0xb6) and c:IsXyzSummonable(g,g:GetCount(),g:GetCount())
end
function c95480007.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
	local g=Duel.GetMatchingGroup(c95480007.spfilter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	local b1=g:CheckSubGroup(c95480007.fselect2,1,ft,tp)
	if chk==0 then return ft>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and (b1 or b2) end
	if b1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=g:SelectSubGroup(tp,c95480007.fselect2,false,1,ft,tp)
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c95480007.act2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c95480007.spfilterx,nil,e,tp)
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
	local tg=Duel.GetMatchingGroup(c95480007.xyzfilter,tp,LOCATION_EXTRA,0,nil,og)
	if og:GetCount()==g:GetCount() and tg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=tg:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,rg:GetFirst(),og,og:GetCount(),og:GetCount())
	end
end

function c95480007.filter0(c)
	return c:IsOnField() and c:IsAbleToRemove()
end
function c95480007.filter1(c,e)
	return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c95480007.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xb7) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c95480007.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c95480007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c95480007.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c95480007.filter3,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c95480007.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c95480007.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c95480007.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c95480007.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c95480007.filter3,tp,LOCATION_GRAVE,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c95480007.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c95480007.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end

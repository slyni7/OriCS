hebi=hebi or {}
Hebi=hebi

--상대 몬스터 존 / 묘지 위치를 소재로 참조하는 의식 소환(제외)
function hebi.AddRitualProcExLoc(c,filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter)
	summon_location=summon_location or LOCATION_HAND
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(hebi.ExLocRitualTarget(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter))
	e1:SetOperation(hebi.ExLocRitualOperation(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter))
	c:RegisterEffect(e1)
	return e1
end
function hebi.ExLocRitualTarget(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					local mg=Duel.GetRitualMaterial(tp)
					if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp,true) end
					local exg=nil
					if grave_filter then
						exg=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,0x10,0x04+0x10,nil,grave_filter)
					end
					return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,summon_location,0,1,nil,filter,e,tp,mg,exg,level_function,greater_or_equal,true)
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,summon_location)
				if grave_filter then
					Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
				end
			end
end
function hebi.ExLocRitualOperation(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local mg=Duel.GetRitualMaterial(tp)
				if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp) end
				local exg=nil
				if grave_filter then
					exg=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,0x10,0x10,nil,grave_filter)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,Auxiliary.NecroValleyFilter(Auxiliary.RitualUltimateFilter),tp,summon_location,0,1,1,nil,filter,e,tp,mg,exg,level_function,greater_or_equal)
				local tc=tg:GetFirst()
				if tc then
					mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
					if exg then
						mg:Merge(exg)
					end
					if tc.mat_filter then
						mg=mg:Filter(tc.mat_filter,tc,tp)
					else
						mg:RemoveCard(tc)
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local lv=level_function(tc)
					Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(tc,lv,greater_or_equal)
					local mat=mg:SelectSubGroup(tp,Auxiliary.RitualCheck,false,1,lv,tp,tc,lv,greater_or_equal)
					Auxiliary.GCheckAdditional=nil
					tc:SetMaterial(mat)
					Duel.ReleaseRitualMaterial(mat)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
			end
end

--이상이 되도록
function hebi.AddRitualProcGreaterExLoc(c,filter,summon_location,grave_filter,mat_filter)
	return hebi.AddRitualProcExLoc(c,filter,Card.GetOriginalLevel,"Greater",summon_location,grave_filter,mat_filter)
end
function hebi.AddRitualProcGreaterExLocCode(c,code1,summon_location,grave_filter,mat_filter)
	aux.AddCodeList(c,code1)
	return hebi.AddRitualProcGreaterExLoc(c,aux.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter)
end

--합이 같아지도록
function hebi.AddRitualProcEqualExLoc(c,filter,summon_location,grave_filter,mat_filter)
	return hebi.AddRitualProcExLoc(c,filter,Card.GetOriginalLevel,"Equal",summon_location,grave_filter,mat_filter)
end
function hebi.AddRitualProcEqualExLocCode(c,code1,summon_location,grave_filter,mat_filter)
	aux.AddCodeList(c,code1)
	return hebi.AddRitualProcEqualExLoc(c,aux.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter)
end

--확장(레벨의 합이 같아지도록)
function hebi.AddRitualProcEqual2ExLoc(c,filter,summon_location,grave_filter,mat_filter)
	return hebi.AddRitualProcExLoc(c,filter,Card.GetLevel,"Equal",summon_location,grave_filter,mat_filter)
end
function hebi.AddRitualProcEqual2ExLocCode(c,code1,summon_location,grave_filter,mat_filter)
	aux.AddCodeList(c,code1)
	return hebi.AddRitualProcEqual2ExLoc(c,aux.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter)
end
function hebi.AddRitualProcEqual2ExLocCode2(c,code1,code2,summon_location,grave_filter,mat_filter)
	aux.AddCodeList(c,code1,code2)
	return hebi.AddRitualProcEqual2ExLoc(c,aux.FilterBoolFunction(Card.IsCode,code1,code2),summon_location,grave_filter,mat_filter)
end

--확장(레벨 이상이 되도록)
function hebi.AddRitualProcGreater2ExLoc(c,filter,summon_location,grave_filter,mat_filter)
	return hebi.AddRitualProcExLoc(c,filter,Card.GetLevel,"Greater",summon_location,grave_filter,mat_filter)
end
function hebi.AddRitualProcGreater2ExLocCode(c,code1,summon_location,grave_filter,mat_filter)
	aux.AddCodeList(c,code1)
	return hebi.AddRitualProcGreater2ExLoc(c,aux.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter)
end
function hebi.AddRitualProcGreater2ExLocCode2(c,code1,code2,summon_location,grave_filter,mat_filter)
	aux.AddCodeList(c,code1,code2)
	return hebi.AddRitualProcGreater2ExLoc(c,aux.FilterBoolFunction(Card.IsCode,code1,code2),summon_location,grave_filter,mat_filter)
end


--뿌리 왕저: 코스트
function hebi.rootsfilter1(c,e,tp)
	if c:IsLocation(0x02) then
		return c:IsAbleToGraveAsCost()
	else
		return e:GetHandler():IsSetCard(0xc89) and c:IsHasEffect(endofroots,tp) and c:IsAbleToRemoveAsCost()
	end
end
function hebi.rootscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local other=nil
	if e:GetHandler():IsCode(81242140) then other=e:GetHandler() end
	if chk==0 then
		return Duel.IsExistingMatchingCard(hebi.rootsfilter1,tp,0x02+0x10,0,1,other,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectMatchingCard(tp,hebi.rootsfilter1,tp,0x02+0x10,0,1,1,other,e,tp)
	local te=tg:GetFirst():IsHasEffect(endofroots,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
	else
		Duel.SendtoGrave(tg,REASON_COST)
	end
end
function hebi.bfgrootscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(hebi.rootsfilter1,tp,0x02+0x10,0,1,nil,e,tp)
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectMatchingCard(tp,hebi.rootsfilter1,tp,0x02+0x10,0,1,1,nil,e,tp)
	local te=tg:GetFirst():IsHasEffect(endofroots,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
	else
		Duel.SendtoGrave(tg,REASON_COST)
	end
end


--천정의
--퍼시프로에서 인용된 스크립트입니다.
--check for free Zone for monsters to be Special Summoned except from Extra Deck
function hebi.MZFilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 and c:IsControler(tp)
end
--check for Free Monster Zones
function hebi.ChkfMMZ(sumcount)
	return	function(sg,e,tp,mg)
				return sg:FilterCount(hebi.MZFilter,nil,tp)+Duel.GetLocationCount(tp,LOCATION_MZONE)>=sumcount
			end
end

if YGOPRO_VERSION~="Percy/EDO" then
	
	--SelectUnselectLoop
	function Auxiliary.SelectUnselectLoop(c,sg,mg,e,tp,minc,maxc,rescon)
		local res
		if sg:GetCount()>=maxc then return false end
		sg:AddCard(c)
		if sg:GetCount()<minc then
			res=mg:IsExists(Auxiliary.SelectUnselectLoop,1,sg,sg,mg,e,tp,minc,maxc,rescon)
		elseif sg:GetCount()<maxc then
			res=(not rescon or rescon(sg,e,tp,mg)) or mg:IsExists(Auxiliary.SelectUnselectLoop,1,sg,sg,mg,e,tp,minc,maxc,rescon)
		else
			res=(not rescon or rescon(sg,e,tp,mg))
		end
		sg:RemoveCard(c)
		return res
	end
	function Auxiliary.SelectUnselectGroup(g,e,tp,minc,maxc,rescon,chk,seltp,hintmsg,cancelcon,breakcon)
		local minc=minc and minc or 1
		local maxc=maxc and maxc or 99
		if chk==0 then return g:IsExists(Auxiliary.SelectUnselectLoop,1,nil,Group.CreateGroup(),g,e,tp,minc,maxc,rescon) end
		local hintmsg=hintmsg and hintmsg or 0
		local sg=Group.CreateGroup()
		while true do
			local cancel=sg:GetCount()>=minc and (not cancelcon or cancelcon(sg,e,tp,g))
			local mg=g:Filter(Auxiliary.SelectUnselectLoop,sg,sg,g,e,tp,minc,maxc,rescon)
				if (breakcon and breakcon(sg,e,tp,mg)) or mg:GetCount()<=0 or sg:GetCount()>=maxc then break end
			Duel.Hint(HINT_SELECTMSG,seltp,hintmsg)
			local tc=mg:SelectUnselect(sg,seltp,cancel,cancel)
			if not tc then break end
			if sg:IsContains(tc) then
				sg:RemoveCard(tc)
			else
				sg:AddCard(tc)
			end
		end
		return sg
	end
end

--라스트 판타즘
--싱크로 프로시저
function hebi.AddLPSynchroProcedure(c,f1,f2,f3,f4,minc,maxc,gc)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(Auxiliary.Stringid(81257040,4))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(0x40)
	e1:SetCondition(hebi.syncn(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetTarget(hebi.syntg(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetOperation(hebi.synop(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end

function hebi.SynMatfil(c,syncard)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function hebi.SynLimfil(c,f,e,syncard)
	return f and not f(e,c,syncard)
end
function hebi.GetSynMats(tp,syncard)
	local mg=Duel.GetMatchingGroup(hebi.SynMatfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil,syncard)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	return mg
end
function hebi.syncn(f1,f2,f3,f4,minc,maxc,gc)
	return	function(e,c,smat,mg1,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1
					mgchk=true
				else
					mg=hebi.GetSynMats(tp,c)
				end
				if smat~=nil then mg:AddCard(smat) end
				return mg:IsExists(hebi.SynMixFilter1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc,mgchk)
			end
end
function hebi.syntg(f1,f2,f3,f4,minc,maxc,gc)
return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local g=Group.CreateGroup()
				local mg
				if mg1 then
					mg=mg1
				else
					mg=hebi.GetSynMats(tp,c)
				end
				if smat~=nil then mg:AddCard(smat) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local c1=mg:FilterSelect(tp,hebi.SynMixFilter1,1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc):GetFirst()
				g:AddCard(c1)
				if f2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					local c2=mg:FilterSelect(tp,hebi.SynMixFilter2,1,1,c1,f2,f3,f4,minc,maxc,c,mg,smat,c1,gc):GetFirst()
					g:AddCard(c2)
					if f3 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
						local c3=mg:FilterSelect(tp,hebi.SynMixFilter3,1,1,Group.FromCards(c1,c2),f3,f4,minc,maxc,c,mg,smat,c1,c2,gc):GetFirst()
						g:AddCard(c3)
					end
				end
				local g4=Group.CreateGroup()
				for i=0,maxc-1 do
					local mg2=mg:Clone()
					if f4 then
						mg2=mg2:Filter(f4,g,c)
					else
						mg2:Sub(g)
					end
					local cg=mg2:Filter(hebi.SynMixCheckRecursive,g4,tp,g4,mg2,i,minc,maxc,c,g,smat,gc)
					if cg:GetCount()==0 then break end
					local minct=1
					if hebi.SynMixCheckGoal(tp,g4,minc,i,c,g,smat,gc) then
						minct=0
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					local tg=cg:Select(tp,minct,1,nil)
					if tg:GetCount()==0 then break end
					g4:Merge(tg)
				end
				g:Merge(g4)
				if g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function hebi.synop(f1,f2,f3,f4,minct,maxc,gc)
	return function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
			end
end
function hebi.SynMixFilter1(c,f1,f2,f3,f4,minc,maxc,syncard,mg,smat,gc,mgchk)
	return (not f1 or f1(c,syncard)) and mg:IsExists(hebi.SynMixFilter2,1,c,f2,f3,f4,minc,maxc,syncard,mg,smat,c,gc,mgchk)
end
function hebi.SynMixFilter2(c,f2,f3,f4,minc,maxc,syncard,mg,smat,c1,gc,mgchk)
	if f2 then
		return f2(c,syncard,c1) and mg:IsExists(hebi.SynMixFilter3,1,Group.FromCards(c1,c),f3,f4,minc,maxc,syncard,mg,smat,c1,c,gc,mgchk)
	else
		return mg:IsExists(hebi.SynMixFilter4,1,c1,f4,minc,maxc,syncard,mg,smat,c1,nil,nil,gc,mgchk)
	end
end
function hebi.SynMixFilter3(c,f3,f4,minc,maxc,syncard,mg,smat,c1,c2,gc,mgchk)
	if f3 then
		return f3(c,syncard,c1,c2) and mg:IsExists(hebi.SynMixFilter4,1,Group.FromCards(c1,c2,c),f4,minc,maxc,syncard,mg,smat,c1,c2,c,gc,mgchk)
	else
		return mg:IsExists(hebi.SynMixFilter4,1,Group.FromCards(c1,c2),f4,minc,maxc,syncard,mg,smat,c1,c2,nil,gc,mgchk)
	end
end
function hebi.SynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc,mgchk)
	if f4 and not f4(c,syncard,c1,c2,c3) then return false end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg=mg1:Clone()
	if f4 then
		mg=mg:Filter(f4,sg,syncard)
	else
		mg:Sub(sg)
	end
	return hebi.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat,gc,mgchk)
end
function hebi.SynMixCheck(mg,sg1,minc,maxc,syncard,smat,gc,mgchk)
	local tp=syncard:GetControler()
	local sg=Group.CreateGroup()
	if minc==0 and hebi.SynMixCheckGoal(tp,sg1,0,0,syncard,sg,smat,gc,mgchk) then return true end
	if maxc==0 then return false end
	return mg:IsExists(hebi.SynMixCheckRecursive,1,nil,tp,sg,mg,0,minc,maxc,syncard,sg1,smat,gc,mgchk)
end
function hebi.SynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk)
	sg:AddCard(c)
	ct=ct+1
	local res=hebi.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
		or (ct<maxc and mg:IsExists(hebi.SynMixCheckRecursive,1,sg,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end

function hebi.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc)
	if ct<minc then
		return false
	end
	local g=sg:Clone()
	g:Merge(sg1)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then
		return false
	end
	if gc and not gc(g) then
		return false
	end
	if smat and not g:IsContains(smat) then
		return false
	end
	if not Auxiliary.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then
		return false
	end
	if not g:CheckWithSumEqual(Card.GetSynchroLevel,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard)
		and (not g:IsExists(Card.IsHasEffect,1,nil,89818984)
		or not g:CheckWithSumEqual(Auxiliary.GetSynchroLevelFlowerCardian,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard))
		and not g:IsExists(Card.IsHasEffect,1,nil,81257000)
		then
		return false
	end
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local hct=hg:GetCount()
	if hct>0 then
		local found=false
		for c in aux.Next(g) do
			local he,hf,hmin,hmax=c:GetHandSynchro()
			if he then
				found=true
				if hf and hg:IsExists(Auxiliary.SynLimitFilter,1,c,hf,he) then
					return false
				end
				if (hmin and hct<hmin) or (hmax and hct>hmax) then
					return false
				end
			end
		end
		if not found then return false end
	end
	for c in aux.Next(g) do
		local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		if le then
			local lct=g:GetCount()-1
			if lloc then
				local llct=g:FilterCount(Card.IsLocation,c,lloc)
				if llct~=lct then
					return false
				end
			end
			if lf and g:IsExists(Auxiliary.SynLimitFilter,1,c,lf,le) then
				return false
			end
			if (lmin and lct<lmin) or (lmax and lct>lmax) then
				return false
			end
		end
	end
	return true
end
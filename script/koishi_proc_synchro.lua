CYAN_EFFECT_AGRAVAIN=111210018
local slv=Card.GetSynchroLevel
function Card.GetSynchroLevel(c,sc)
	if c:IsHasEffect(CYAN_EFFECT_AGRAVAIN) then
		local m=_G["c"..c:GetCode()]
		if m.CyanSynCon(sc) then
			return m.CyanSynLevel
		end
	end
	return slv(c,sc)
end

local csm=Card.IsCanBeSynchroMaterial
function Card.IsCanBeSynchroMaterial(c,sc)
	if c:IsHasEffect(CYAN_EFFECT_AGRAVAIN) then
		return true
	end
	return csm(c,sc)
end
function Auxiliary.AddSynchroProcedure(c,f1,f2,minc,maxc,a,b)
	if type(f2)=="number" then
		if f2==minc then
			if b==nil then
				b=99
			end
			if f2==1 then
				aux.AddSynchroMixProcedure(c,aux.Tuner(f1),nil,nil,maxc,a,b)
			elseif f2==2 then
				aux.AddSynchroMixProcedure(c,aux.Tuner(f1),f1,nil,maxc,a,b)
			elseif f2==3 then
				aux.AddSynchroMixProcedure(c,aux.Tuner(f1),f1,f1,maxc,a,b)
			end
		end
		local mt=getmetatable(c)
		mt.alice_minimum=1+f2
	else
		if maxc==nil then
			maxc=99
		end
		aux.AddSynchroMixProcedure(c,aux.Tuner(f1),nil,nil,f2,minc,maxc)
		local mt=getmetatable(c)
		mt.alice_minimum=1+minc
	end
end
function Auxiliary.AddSynchroMixProcedure(c,f1,f2,f3,f4,minc,maxc,gc)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.SynMixCondition(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetTarget(Auxiliary.SynMixTarget(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetOperation(Auxiliary.SynMixOperation(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	local sum=1+minc
	if f2 then
		sum=sum+1
	end
	if f3 then
		sum=sum+1
	end
	local mt=getmetatable(c)
	mt.alice_minimum=sum
end

function Auxiliary.SynMixCondition(f1,f2,f3,f4,minc,maxc,gc)
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
					mg=Auxiliary.GetSynMaterials(tp,c)
				end
				if smat~=nil then mg:AddCard(smat) end
				if c:IsCode(18453195) then
					if not mg:IsExists(f1,1,nil) then
						return false
					end
				end
				if c:IsCustomType(CUSTOMTYPE_SQUARE) then
					if not aux.IsFitSquare(mg,c.square_mana) then
						return false
					end
				end
				return mg:IsExists(Auxiliary.SynMixFilter1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc,mgchk)
			end
end

function Auxiliary.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc)
	if ct<minc then
		return false
	end
	local g=sg:Clone()
	g:Merge(sg1)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then
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
		and not g:IsExists(Card.IsHasEffect,1,nil,17280001)
		then
		return false
	end
	if gc and not gc(g) then
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
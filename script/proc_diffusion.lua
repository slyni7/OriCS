if not aux.DiffusionProcedure then
	aux.DiffusionProcedure = {}
	Diffusion = aux.DiffusionProcedure
end
if not Diffusion then
	Diffusion = aux.DiffusionProcedure
end

EFFECT_DIFFUSION_MATERIAL=0x300
EFFECT_DIFFUSION_SUBSTITUTE=0x301
CUSTOMTYPE_DIFFUSION=0x4000
SUMMON_TYPE_DIFFUSION=0x4000a000

function Card.CheckDiffusionSubstitute(c,dc)
	local te=c:IsHasEffect(EFFECT_DIFFUSION_SUBSTITUTE)
	if te then
		return true
	end
	return false
end

function Card.CheckDiffusionMaterial(c,mc,g,chkf)
	local te=c:IsHasEffect(EFFECT_DIFFUSION_MATERIAL)
	if not te then
		return false
	end
	local con=te:GetCondition()
	return con(te,mc,g,chkf)
end

function Card.SelectDiffusionMaterial(c,tp,mc,g,chkf)
	local te=c:IsHasEffect(EFFECT_DIFFUSION_MATERIAL)
	if not te then
		return
	end
	local op=te:GetOperation()
	local sg=op(te,tp,g,tp,0,Effect.GlobalEffect(),0,tp,mc,chkf)
	return sg
end

--Diffusion monster, mixed resultants
function Diffusion.AddProcMix(c,sub,dmat,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	--From Here
	local val={...}
	local fun={}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,dc)
				return val[i](c,dc)
			end
		elseif type(val[i])=='table' then
			fun[i]=function(c,dc)
				for _,dcode in ipairs(val[i]) do
					if type(dcode)=='function' then
						if dcode(c,dc) then
							return true
						end
					else
						if c:IsCode(dcode) then
							return true
						end
					end
				end
				return false
			end
			for _,dcode in ipairs(val[i]) do
				if type(dcode)~='function' then
					mat[fcode]=true
				end
			end
		else
			fun[i]=function(c,dc)
				return c:IsCode(val[i])
			end
			mat[val[i]]=true
		end
	end
	if c.material==nil then
		local mt=getmetatable(c)
		mt.material=mat
	end
	for index,_ in pairs(mat) do
		Auxiliary.AddCodeList(c,index)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIFFUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(Auxiliary.DConditionMix(sub,dmat,table.unpack(fun)))
	e1:SetOperation(Auxiliary.DOperationMix(sub,dmat,table.unpack(fun)))
	c:RegisterEffect(e1)
end

function Auxiliary.DConditionFilterMix(c,dc,...)
	for i,f in ipairs({...}) do
		if f(c,dc) then
			return true
		end
	end
	return false
end

function Auxiliary.DConditionMix(sub,dmat,...)
	local funs={...}
	return
		function(e,mc,g,chkf)
			if mc==nil then
				return true
			end
			local c=e:GetHandler()
			local tp=c:GetControler()
			local mg=g:Filter(Auxiliary.DConditionFilterMix,nil,c,table.unpack(funs))
			mg:AddCard(c)
			Duel.SetSelectedCard(Group.FromCards(c))
			return mg:CheckSubGroup(Auxiliary.DCheckMixGoal,#funs+1,#funs+1,c,tp,sub,dmat,mc,chkf,table.unpack(funs))
		end
end

function Auxiliary.DOperationMix(sub,dmat,...)
	local funs={...}
	return
		function(e,tp,eg,ep,ev,re,r,rp,mc,chkf)
			local c=e:GetHandler()
			local tp=c:GetControler()
			local mg=eg:Filter(Auxiliary.DConditionFilterMix,nil,c,table.unpack(funs))
			mg:AddCard(c)
			Duel.SetSelectedCard(Group.FromCards(c))
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=mg:SelectSubGroup(tp,Auxiliary.DCheckMixGoal,false,#funs+1,#funs+1,c,tp,sub,dmat,mc,chkf,table.unpack(funs))
			sg:KeepAlive()
			return sg
		end
end

function Auxiliary.DCheckMix(c,sg,g,dc,tp,dmat,mc,chkf,fun1,fun2,...)
	if fun2 then
		g:AddCard(c)
		local res=false
		if fun1(c,dc) then
			res=sg:IsExists(Auxiliary.DCheckMix,1,g,sg,g,dc,tp,dmat,mc,chkf,fun2,...)
		end
		g:RemoveCard(c)
		return res
	else
		g:AddCard(c)
		local res=false
		if fun1(c,dc) then
			res=true
			if chkf~=PLAYER_NONE then	
				local ft1=Duel.GetMZoneCount(tp,mc)
				local ft2=Duel.GetLocationCountFromEx(tp,tp,mc,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
				local ft3=Duel.GetLocationCountFromEx(tp,tp,mc,TYPE_PENDULUM+TYPE_LINK)
				local ft=Duel.GetUsableMZoneCount(tp)
				if mc:IsLocation(LOCATION_MZONE) then
					ft=ft+1
				end
				if #g>ft then
					res=false
				end
				if g:FilterCount(function(c)
					return not c:IsLocation(LOCATION_EXTRA)
				end,nil)>ft1 then
					res=false
				end
				if g:FilterCount(function(c)
					return c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
				end,nil)>ft2 then
					res=false
				end
				if g:FilterCount(function(c)
					return c:IsLocation(LOCATION_EXTRA) and (c:IsType(TYPE_LINK) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
				end,nil)>ft3 then
					res=false
				end
			end
		end
		g:RemoveCard(c)
		return res
	end
end

function Auxiliary.DCheckMixGoal(sg,dc,tp,sub,dmat,mc,chkf,...)
	local g=Group.CreateGroup()
	return (dmat(mc) or (sub and mc:CheckDiffusionSubstitute(dc))) and sg:IsExists(Auxiliary.DCheckMix,1,nil,sg,g,dc,tp,dmat,mc,chkf,...)
end

--Diffision monster, dmat = name +
function Diffusion.AddProcCode(c,dmat,code1,sub)
	return Diffusion.AddProcMix(c,sub,dmat,code1)
end

--Diffision monster, dmat = name + name +
function Diffusion.AddProcCode2(c,dmat,code1,code2,sub)
	return Diffusion.AddProcMix(c,sub,dmat,code1,code2)
end

--Diffision monster, dmat = name + name + name +
function Diffusion.AddProcCode3(c,dmat,code1,code2,code3,sub)
	return Diffusion.AddProcMix(c,sub,dmat,code1,code2,code3)
end

--Diffision monster, dmat = name + name + name + name +
function Diffusion.AddProcCode4(c,dmat,code1,code2,code3,code4,sub)
	return Diffusion.AddProcMix(c,sub,dmat,code1,code2,code3,code4)
end

--Diffision monster, dmat = name * n +
function Diffusion.AddProcCodeRep(c,dmat,code1,cc,sub)
	local code={}
	for i=1,cc do
		code[i]=code1
	end
	return Diffusion.AddProcMix(c,sub,dmat,table.unpack(code))
end

--Diffusion monster, dmat = condition * n +
function Diffusion.AddProcFun(c,dmat,f,cc,sub)
	local fun={}
	for i=1,cc do
		fun[i]=f
	end
	return Diffusion.AddProcMix(c,sub,dmat,table.unpack(fun))
end

--Diffusion monster, dmat = (name/condition * n) * n
function Diffusion.AddProcMixN(c,sub,dmat,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local t={}
	local n={}
	if #val%2~=0 then return end
	for i=1,#val do
		if i%2~=0 then
			table.insert(t,val[i])
		else
			table.insert(n,val[i])
		end
	end
	if #t~=#n then return end
	local fun={}
	for i=1,#t do
		for j=1,n[i] do
			table.insert(fun,t[i])
		end
	end
	return Diffusion.AddProcMix(c,sub,table.unpack(fun))
end

--The function generates a default Diffusion Summon effect. By default it's usable for Spells/Traps, usage in monsters requires changing type and code afterwards.
--c				card that uses the effect
--diffilter		filter for the monster to be Diffusion Summoned
--matfilter		restriction on the default materials returned by GetDiffusionMaterial
--extrafil		function that returns a group of extra cards that can be used as fusion materials, and as second optional parameter the additional filter function
--extraop		function called right before sending the monsters to the graveyard as material
--gc			mandatory card or function returning a group to be used (for effects like Soprano)
--stage2		function called after the monster has been summoned
--exactcount	
--location		location where to Diffusion Summon monsters from
--chkf			DIFPROC flags for the Diffusion Summon
--desc			summon effect description
function Diffusion.CreateSummonEff(c,diffilter,matfilter,extrafil,extraop,gc,stage2,exactcount,value,location,chkf,desc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	if desc then
		e1:SetDescription(desc)
	else
		--e1:SetDescription(0)
	end
	e1:SetTarget(Diffusion.SummonEffTG(diffilter,matfilter,extrafil,extraop,gc,stage2,exactcount,value,location,chkf,desc))
	e1:SetOperation(Diffusion.SummonEffOP(diffilter,matfilter,extrafil,extraop,gc,stage2,exactcount,value,location,chkf,desc))
	return e1
end
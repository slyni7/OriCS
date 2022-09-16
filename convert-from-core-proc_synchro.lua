Auxiliary.NonTuner=Synchro.NonTuner

function Auxiliary.Tuner(f,...)
	local ext_params={...}
	return	function(target)
				return target:IsType(TYPE_TUNER) and (not f or f(target,table.unpack(ext_params)))
			end
end

function Auxiliary.AddSynchroProcedure(c,...)
	local t={...}
	if type(t[2])~="number" then
		Synchro.AddProcedure(c,t[1],1,1,t[2],t[3],t[4] or 99)
	else
		Synchro.AddProcedure(c,...)
	end
end

function Auxiliary.AddSynchroMixProcedure(c,f1,f2,f3,f4,minc,maxc,gc)
	local ct=0
	local t={}
	if f2 then
		table.insert(t,f2)
		ct=ct+1
	end
	if f3 then
		table.insert(t,f3)
		ct=ct+1
	end
	if f4==nil then
		f4=aux.TRUE
	end
	table.insert(t,f4)
	local req=Auxiliary.SynchroMixRequire(table.unpack(t))
	Synchro.AddProcedure(c,nil,1,1,nil,minc+ct,maxc+ct,f1,nil,nil,req,gc)
end
function Auxiliary.SynchroMixRequire(...)
	local t={...}
	return function(g,sc,tp)
		local sg=Group.CreateGroup()
		return g:IsExists(Auxiliary.SynchroMixRequireCheck,1,nil,g,sg,sc,tp,table.unpack(t))
	end
end
function Auxiliary.SynchroMixRequireCheck(c,mg,sg,sc,tp,f1,f2,...)
	if f2 then
		sg:AddCard(c)
		local res=false
		if f1(c,sc,SUMMON_TYPE_SYNCHRO,tp) then
			res=mg:IsExists(Auxiliary.SynchroMixRequireCheck,1,sg,mg,sg,sc,tp,f2,...)
		end
		sg:RemoveCard(c)
		return res
	else
		sg:AddCard(c)
		local res=false
		if f1(c,sc,SUMMON_TYPE_SYNCHRO,tp) then
			res=#mg==#sg or mg:IsExists(Auxiliary.SynchroMixRequireCheck,1,sg,mg,sg,sc,tp,f1)
		end
		sg:RemoveCard(c)
		return res
	end
end
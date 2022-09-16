CUSTOMTYPE_BEYOND=0x4
REASON_BEYOND=0x300
SUMMON_TYPE_BEYOND=0x4000c000

EFFECT_MUST_BE_BMATERIAL=112800000

function Card.GetBYDLV(c,bool)
	local mt=getmetatable(c)
	if bool then
		return mt.byd_lv_value
	end
	return mt.byd_lv,mt.byd_lv_value
end
function Card.GetBYDATK(c,bool)
	local mt=getmetatable(c)
	if bool then
		return mt.byd_atk_value
	end
	return mt.byd_atk,mt.byd_atk_value
end
function Card.GetBYDDEF(c,bool)
	local mt=getmetatable(c)
	if bool then
		return mt.byd_def_value
	end
	return mt.byd_def,mt.byd_def_value
end

Beyond={}
BYD=Beyond

function Auxiliary.BeyondRepeat(f,min,max)
	return {f,min,max}
end
function BYD:LV(value)
	return {"BYD:LV",value}
end
function BYD:ATK(value)
	return {"BYD:ATK",value}
end
function BYD:DEF(value)
	return {"BYD:DEF",value}
end

function Auxiliary.AddBeyondProcedure(c,gf,dir,...)
	local f={...}
	local mt=getmetatable(c)
	for i=1,#f do
		if type(f[i])=="string" then
			if f[i]=="BYD:LV" or f[i]=="Level" or f[i]=="L" then
				mt.byd_lv=true
			elseif f[i]=="BYD:ATK" or f[i]=="Attack" or f[i]=="A" then
				mt.byd_atk=true
			elseif f[i]=="BYD:DEF" or f[i]=="Defense" or f[i]=="D" then
				mt.byd_def=true
			end
		elseif type(f[i])=="table" then
			local v1,v2=table.unpack(f[i])
			if v1=="BYD:LV" or v1=="Level" or v1=="L" then
				mt.byd_lv=true
				mt.byd_lv_value=v2
			elseif v1=="BYD:ATK" or v1=="Attack" or v1=="A" then
				mt.byd_atk=true
				mt.byd_atk_value=v2
			elseif v1=="BYD:DEF" or v1=="Defense" or v1=="D" then
				mt.byd_def=true
				mt.byd_def_value=v2
			end
		end
	end
	mt.CardType_Beyond=true
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_BEYOND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetDescription(aux.Stringid(112800000,0))
	e1:SetCondition(Auxiliary.BeyondCondition(gf,dir,table.unpack(f)))
	e1:SetTarget(Auxiliary.BeyondTarget(gf,dir,table.unpack(f)))
	e1:SetOperation(Auxiliary.BeyondOperation(gf,dir,table.unpack(f)))
	c:RegisterEffect(e1)
	return e1
end

function Auxiliary.BeyondConditionFilter(c,bc)
	return c:IsFaceup() --and c:IsCanBeBeyondMaterial(bc)
end
function Auxiliary.BeyondCheckGoal(sg,tp,bc,gf,dir,...)
	local f={...}
	local g=Group.CreateGroup()
	return Auxiliary.BeyondCheck(sg,bc,dir,table.unpack(f))
		and Duel.GetLocationCountFromEx(tp,tp,sg,bc)>0 and (not gf or gf(sg))
end
function Auxiliary.BeyondCheck(sg,bc,dir,...)
	local f={...}
	local crits={}
	local filts={}
	for i=1,#f do
		if type(f[i])=="string" then
			table.insert(crits,f[i])
		end
		if type(f[i])=="table" then
			local v1,v2,v3=f[i][1],f[i][2],f[i][3]
			if type(v1)=="string" then
				table.insert(crits,v1)
				table.insert(filts,{1,1})
			elseif type(v1)=="function" then
				if v3==nil then
					v3=v2
				end
				if v3>8-#f then
					v3=8-#f
				end
				if v3>#sg-#f+1 then
					v3=#sg-#f+1
				end
				if v2>v3 then
					return false
				end
				table.insert(filts,{v2,v3})
			end
		else
			table.insert(filts,{1,1})
		end
	end
	local maxs=0
	for i=1,#filts do
		local filt=filts[i]
		local min,max=filt[1],filt[2]
		maxs=maxs+max
	end
	if maxs>#sg then
		return false
	end
	local beyt={}
	local tc=sg:GetFirst()
	while tc do
		table.insert(beyt,tc)
		tc=sg:GetNext()
	end
	if crits[1]=="BYD:LV" or crits[1]=="Level" or crits[1]=="L" then
		if dir==">" then
			table.sort(beyt,function(a,b) return a:GetLevel()>b:GetLevel() end)
		elseif dir=="<" then
			table.sort(beyt,function(a,b) return a:GetLevel()<b:GetLevel() end)
		end
	elseif crits[1]=="BYD:ATK" or crits[1]=="Attack" or crits[1]=="A" then
		if dir==">" then
			table.sort(beyt,function(a,b) return a:GetAttack()>b:GetAttack() end)
		elseif dir=="<" then
			table.sort(beyt,function(a,b) return a:GetAttack()<b:GetAttack() end)
		end
	elseif crits[1]=="BYD:DEF" or crits[1]=="Defense" or crits[1]=="D" then
		if dir==">" then
			table.sort(beyt,function(a,b) return a:GetDefense()>b:GetDefense() end)
		elseif dir=="<" then
			table.sort(beyt,function(a,b) return a:GetDefense()<b:GetDefense() end)
		end
	end
	if not Auxiliary.BeyondCheckTable(beyt,crits[1],filts,bc,dir,table.unpack(f)) then
		return false
	end
	if crits[2] then
		for i=2,#crits do
			if not Auxiliary.BeyondCheckTable(beyt,crits[i],filts,bc,dir,table.unpack(f)) then
				return false
			end
		end
	end
	return true
end

function Auxiliary.BeyondCheckTable(beyt,crit,filts,bc,dir,...)
	local f={...}
	local splits={}
	local qt={}
	for i=1,#filts do
		local filt=filts[i]
		local min,max=filt[1],filt[2]
		table.insert(qt,min)
	end
	local last=false
	repeat
		local sumq=0
		for i=1,#qt do
			sumq=sumq+qt[i]
		end
		if sumq==#beyt then
			local split={}
			for i=1,#qt do
				table.insert(split,qt[i])
			end
			table.insert(splits,split)
		end
		local lastcheck=true
		for i=1,#filts do
			local filt=filts[i]
			local min,max=filt[1],filt[2]
			if qt[i]~=max then
				lastcheck=false
				break
			end
		end
		last=lastcheck
		for i=#filts,1,-1 do
			local filt=filts[i]
			local min,max=filt[1],filt[2]
			if qt[i]~=max then
				qt[i]=qt[i]+1
				break
			else
				qt[i]=min
			end
		end
	until last
	local res=false
	for i=1,#splits do
		local split=splits[i]
		local ct=0
		local sres=true
		for j=1,#split do
			for k=1,split[j] do
				ct=ct+1
				local tc=beyt[ct]
				if not tc then
					break
				end
				local v0=f[j]
				if type(v0)=="function" then
					if not v0(tc) then
						sres=false
					end
				elseif type(v0)=="string" then
					if v0=="BYD:LV" or v0=="Level" or v0=="L" then
						if tc:GetLevel()~=bc:GetLevel() and tc:GetLevel()~=bc:GetBYDLV(true) then
							sres=false
						end
					elseif v0=="BYD:ATK" or v0=="Attack" or v0=="A" then
						if tc:GetAttack()~=bc:GetAttack() and tc:GetAttack()~=bc:GetBYDATK(true) then
							sres=false
						end
					elseif v0=="BYD:DEF" or v0=="Defense" or v0=="D" then
						if tc:GetDefense()~=bc:GetDefense() and tc:GetDefense()~=bc:GetBYDDEF(true) then
							sres=false
						end
					end
				elseif type(v0)=="table" then
					local v1=v0[1]
					if type(v1)=="function" then
						if not v1(tc) then
							sres=false
						end
					elseif type(v1)=="string" then
						if v1=="BYD:LV" or v1=="Level" or v1=="L" then
							if tc:GetLevel()~=bc:GetLevel() and tc:GetLevel()~=bc:GetBYDLV(true) then
								sres=false
							end
						elseif v1=="BYD:ATK" or v1=="Attack" or v1=="A" then
							if tc:GetAttack()~=bc:GetAttack() and tc:GetAttack()~=bc:GetBYDATK(true) then
								sres=false
							end
						elseif v1=="BYD:DEF" or v1=="Defense" or v1=="D" then
							if tc:GetDefense()~=bc:GetDefense() and tc:GetDefense()~=bc:GetBYDDEF(true) then
								sres=false
							end
						end
					end
				end
				if not sres then
					ct=-99999999
					break
				end
				if ct==#beyt and sres then
					res=true
				end
			end
		end
		if res then
			break
		end
	end
	if not res then
		return false
	end
	res=false
	local func=nil
	if crit=="BYD:LV" or crit=="Level" or crit=="L" then
		func=Card.GetLevel
	elseif crit=="BYD:ATK" or crit=="Attack" or crit=="A" then
		func=Card.GetAttack
	elseif crit=="BYD:DEF" or crit=="Defense" or crit=="D" then
		func=Card.GetDefense
	end
	local compbv=0
	if dir==">" then
		compbv=99999999
	elseif dir=="<" then
		compbv=-99999999
	end
	for i=1,#splits do
		local split=splits[i]
		local splitbv=0
		if dir==">" then
			splitbv=99999999
		elseif dir=="<" then
			splitbv=-99999999
		end
		local ct=0
		local sres=true
		for j=1,#split do
			for k=1,split[j] do
				ct=ct+1
				local tc=beyt[ct]
				if not tc then
					break
				end
				if dir==">" then
					splitbv=math.min(splitbv,func(tc))
				elseif dir=="<" then
					splitbv=math.max(splitbv,func(tc))
				end
			end
			if dir==">" and splitbv>compbv then
				sres=false
			elseif dir=="<" and splitbv<compbv then
				sres=false
			end
			if not sres then
				ct=-99999999
				break
			end
			compbv=splitbv
			if ct==#beyt and sres then
				res=true
			end
		end
		if res then
			break
		end
	end
	if not res then
		return false
	end
	return true
end

function Auxiliary.BeyondCondition(gf,dir,...)
	local f={...}
	return
		function(e,c)
			if c==nil then
				return true
			end
			if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then
				return false
			end
			if #f<2 then
				return false
			end
			local tp=c:GetControler()
			local mg=Duel.GetMatchingGroup(Auxiliary.BeyondConditionFilter,tp,LOCATION_MZONE,0,nil,c)
			local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_BMATERIAL)
			if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then
				return false
			end
			Duel.SetSelectedCard(fg)
			return mg:CheckSubGroup(Auxiliary.BeyondCheckGoal,1,7,tp,c,gf,dir,table.unpack(f))
		end
end
function Auxiliary.BeyondTarget(gf,dir,...)
	local f={...}
	return
		function(e,tp,eg,ep,ev,re,r,rp,chk,c)
			local mg=Duel.GetMatchingGroup(Auxiliary.BeyondConditionFilter,tp,LOCATION_MZONE,0,nil,c)
			local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_BMATERIAL)
			Duel.SetSelectedCard(fg)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(112800000,1))
			local cancel=Duel.IsSummonCancelable()
			local sg=mg:SelectSubGroup(tp,Auxiliary.BeyondCheckGoal,cancel,1,7,tp,c,gf,dir,table.unpack(f))
			if sg then
				sg:KeepAlive()
				e:SetLabelObject(sg)
				return true
			else
				return false
			end
		end
end
function Auxiliary.BeyondOperation(gf,dir,...)
	return
		function(e,tp,eg,ep,ev,re,r,rp,c)
			local g=e:GetLabelObject()
			c:SetMaterial(g)
			Duel.SendtoGrave(g,REASON_MATERIAL+REASON_BEYOND)
			local tc=g:GetFirst()
			while tc do
				Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,e,REASON_BEYOND,tp,tp,0)
				tc=g:GetNext()
			end
			Duel.RaiseEvent(g,EVENT_BE_MATERIAL,e,REASON_BEYOND,tp,tp,0)
			g:DeleteGroup()
		end
end

--융합 타입 삭제

	local type=Card.GetType
	Card.GetType=function(c)
	if c.CardType_Beyond then
		return bit.bor(type(c),TYPE_FUSION)-TYPE_FUSION
	end
	return type(c)
end
--
	local otype=Card.GetOriginalType
	Card.GetOriginalType=function(c)
	if c.CardType_Beyond then
		return bit.bor(otype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return otype(c)
end
--
	local ftype=Card.GetFusionType
	Card.GetFusionType=function(c)
	if c.CardType_Beyond then
		return bit.bor(ftype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ftype(c)
end
--
	local ptype=Card.GetPreviousTypeOnField
	Card.GetPreviousTypeOnField=function(c)
	if c.CardType_Beyond then
		return bit.bor(ptype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ptype(c)
end
--
	local itype=Card.IsType
	Card.IsType=function(c,t)
	if c.CardType_Beyond then
		if t==TYPE_FUSION then
			return false
		end
		return itype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return itype(c,t)
end
--
	local iftype=Card.IsFusionType
	Card.IsFusionType=function(c,t)
	if c.CardType_Beyond then
		if t==TYPE_FUSION then
			return false
		end
		return iftype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return iftype(c,t)
end
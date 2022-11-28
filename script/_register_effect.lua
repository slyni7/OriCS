--ver 1.00 by Kasane Ai
if not aux.RegisterEffect then
	aux.RegisterEffect = {}
	RegEff = aux.RegisterEffect
end
if not RegEff then
	RegEff = aux.RegisterEffect
end

--return 값은 하나면 충분하잖아?
local SumReturns = function(table_or_integer)
	if type(table_or_integer)~="table" then return table_or_integer end
	local res = 0
	for k,i in ipairs(table_or_integer) do
		if type(i)~="number" then return table.concat(table_or_integer) end
		res = res + i
	end
	return res
end
local BandReturns = function(table_or_integer)
	if type(table_or_integer)~="table" then return table_or_integer end
	local res = -1
	for k,i in ipairs(table_or_integer) do
		if type(i)~="number" then return table.concat(table_or_integer) end
		res = res & i
	end
	return res
end
local BorReturns = function(table_or_integer)
	if type(table_or_integer)~="table" then return table_or_integer end
	local res = 0
	for k,i in ipairs(table_or_integer) do
		if type(i)~="number" then return table.concat(table_or_integer) end
		res = res | i
	end
	return res
end

--cregeff는 한 번이면 충분하잖아?
local cREFTable = {[0]={}} --RegisterEffectFunction table
local cRegEff = Card.RegisterEffect --int Card.RegisterEffect(Card c,Effect e[,bool forced=false,...])
function RegEff.SetCardRegisterEffectFunction(code,f,manage_return,...)
	if type(code)~="number" or type(f)~="function" then return end
	local params = {...}
	--code 0: Card.RegisterEffect 전체에 적용
	if code==0 then
		local ct=#(cREFTable[0])
		cREFTable[0][ct] = function(e,c)
			return f(e,c,table.unpack(params))	--Effect|table f(e,c,...)
		end
	--code id: 개별 카드에 적용
	else
		if not cREFTable[code] then
			cREFTable[code] = {}
			cREFTable[0] = function(e,c)
				if not c:IsOriginalCode(code) then return nil end
				return f(e,c,table.unpack(params))	--Effect|table|nil f(e,c,...)
			end
		else
			local fz = cREFTable[0]
			cREFTable[0] = function(e,c)
				local e_or_t = fz(e,c)
				if not e_or_t then return nil end
				return f(e_or_t,c,table.unpack(params))	--Effect|table|nil f(e,c,...)
			end
		end
		if manage_return then
			cREFTable[1] = manage_return			--int f(t)
		else
			if not cREFTable[1] then cREFTable[1] = SumReturns end
		end
	end
end
function Card.GetRegisteredEffectCount(c)
	if not c:IsStatus(STATUS_INITIALIZING) then return -1 end
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	if mt.eff_ct and type(mt.eff_ct)=="table" and mt.eff_ct[c] and type(mt.eff_ct[c])=="table" then
		return #(mt.eff_ct[c])
	end
	return -1
end
Card.RegisterEffect = function(c,e,forced,...)
	--init
	local code = c:GetOriginalCode()
	local mt = _G["c"..code]
	if not mt.eff_ct then
		mt.eff_ct = {}
	end
	if not mt.eff_ct[c] then
		mt.eff_ct[c] = {}
	end
	--get new effect(s)
	local manage_return = SumReturns
	local e_or_t = e
	for k,f in ipairs(cREFTable[0]) do
		if type(e_or_t)~="table" then
			local res = f(e_or_t,c)
			if res then e_or_t = res end
		else
			local tt = e_or_t
			e_or_t = {}
			for ,te in ipairs(tt) do
				local re_or_rt = f(te,c)
				if type(re_or_rt)~="table" then
					table.insert(e_or_t,re_or_rt or te)
				else
					for ,re in ipairs(re_or_rt) do table.insert(e_or_t,re) end
				end
			end
		end
	end
	if cREFTable[code] then
		e_or_t = (cREFTable[code][0])(e_or_t,c)
		manage_return = cREFTable[code][1]
	end
	if c:IsStatus(STATUS_INITIALIZING) then
		local ct=c:GetRegisteredEffectCount()
		mt.eff_ct[c][ct] = e_or_t
	end
	--register effect(s)
	if type(e_or_t)~="table" then return cRegEff(c,e_or_t,forced,...) end
	local result = {}
	for k,v in ipairs(e_or_t) do
		result[k] = cRegEff(c,v,forced,...)
	end
	return manage_return(v)
end

--dregeff는 한 번이면 충분하잖아?
local dRegEff = Duel.RegisterEffect --void Duel.RegisterEffect(Effect e, int player)
local dREFTable = {} --RegisterEffectFunction table
function RegEff.SetDuelRegisterEffectFunction(f)
	--Effect f(e,p)
	local ct=#dREFTable
	dREFTable[ct] = function(e,p)
		return f(e,p)
	end
end
Duel.RegisterEffect = function(e,p)
	for k,f in ipairs(dREFTable) do
		e = f(e,p)
	end
	dRegEff(e,p)
end

--regeff는 하나면 충분하잖아?
function RegEff.SetRegisterEffectFunction(c,f,mr)
	if type(c)=="number" then
		RegEff.SetCardRegisterEffectFunction(c,f,mr)
	elseif type(c)=="Card" then
		RegEff.SetCardRegisterEffectFunction(c:GetOriginalCode(),f,mr)
	else
		RegEff.SetDuelRegisterEffectFunction(f)
	end
end

--스크립트 속기용 (deprecated)
Card.grec = Card.GetRegisteredEffectCount
RegEff.sref = RegEff.SetRegisterEffectFunction
RegEff.scref = function(code,ct,f,...)						--Effect|table|nil f(e,c,...)
	local params = {...}
	RegEff.SetCardRegisterEffectFunction(code,
	function(e,c)
		if c:GetRegisteredEffectCount()~=ct then return e end
		return f(e,c,table.unpack(params))
	end)
end
RegEff.sgref = function(f,...) RegEff.scref(0,0,f,...) end	--Effect|table f(e,c,...)
RegEff.sdref = RegEff.SetDuelRegisterEffectFunction			--Effect f(e,p)
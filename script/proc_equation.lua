--¿¡Äû¼Ç ¼ÒÈ¯
SUMMON_TYPE_EQUATION=0x40003000
REASON_EQUATION=0x80000000
CUSTOMTYPE_EQUATION=0x2
EFFECT_CANNOT_BE_EQUATION_MATERIAL=18451018

function Card.IsCanBeEquationMaterial(c,eqc)
	if c:IsForbidden() then
		return false 
	end
	local eset={c:IsHasEffect(EFFECT_CANNOT_BE_EQUATION_MATERIAL)}
	for _,te in pairs(eset) do
		local f=te:GetValue()
		if f==1 then return false end
		if f and f(te,eqc) then return false end
	end
	return true
end

function Auxiliary.AddEquationProcedure(c,gf,equation,...)
	local f=Auxiliary.ENumberToFunction(...)
	local eqfun=equation
	if type(equation)=='number' then
		eqfun=function(...)
			local t={...}
			if not t[1] then
				return equation
			end
			local sum=0
			for i=1,#t do
				sum=sum+f[i]()*t[i]
			end
			if sum==equation then
				return equation
			end
			return false
		end
	end
	local mt=getmetatable(c)
	mt.equation_formula={eqfun,table.unpack(f)}
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_DECK)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetValue(SUMMON_TYPE_EQUATION)
	e1:SetCondition(Auxiliary.EquationCondition(gf,eqfun,table.unpack(f)))
	e1:SetTarget(Auxiliary.EquationTarget(gf,eqfun,table.unpack(f)))
	e1:SetOperation(Auxiliary.EquationOperation(gf,eqfun,table.unpack(f)))
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.ENumberToFunction(...)
	local t={}
	local f={...}
	for i=1,#f do
		if type(f[i])=='number' then
			local s=i-1
			t[i]=function(u,tp,eqc)
				if not u then
					return f[i]
				elseif type(u)=='number' then
					return math.abs(s-tp),LOCATION_MZONE
				elseif type(u)=='userdata' then
					if u.GetOriginalCode then
						return u:IsControler(math.abs(s-tp)) and u:IsLocation(LOCATION_MZONE)
							and u:IsFaceup() and u:IsAbleToDeck() and u:IsCanBeEquationMaterial(eqc)
					elseif u.KeepAlive then
						if u:GetClassCount(Card.GetLevel)==1 then
							return u:GetFirst():GetLevel()
						end
						return false
					end
				elseif type(u)=='Card' then
					return u:IsControler(math.abs(s-tp)) and u:IsLocation(LOCATION_MZONE)
						and u:IsFaceup() and u:IsAbleToDeck() and u:IsCanBeEquationMaterial(eqc)
				elseif type(u)=='Group' then
					if u:GetClassCount(Card.GetLevel)==1 then
						return u:GetFirst():GetLevel()
					end
					return false
				end
				return false
			end
		elseif type(f[i])=='function' then
			t[i]=f[i]
		end
	end
	return t
end
function Auxiliary.GetEquationGroup(tp,...)
	local g=Group.CreateGroup()
	for i,f in ipairs({...}) do
		local p,loc=f(0,tp)
		local sg=nil
		if p==PLAYER_ALL then
			sg=Duel.GetMatchingGroup(f,tp,loc,loc,nil,tp)
		elseif p==tp then
			sg=Duel.GetMatchingGroup(f,tp,loc,0,nil,tp)
		elseif p==1-tp then
			sg=Duel.GetMatchingGroup(f,tp,0,loc,nil,tp)
		end
		g:Merge(sg)
	end
	return g
end
function Auxiliary.GetEquationCount(...)
	local sum=0
	for i,f in ipairs({...}) do
		sum=sum+math.abs(f())
	end
	return sum
end
function Auxiliary.ECheckLoop(c,tp,t,mg,sg,gf,equation,eqc,...)
	local f={...}
	local last=0
	for i=1,#t do
		if f[#t+1-i]()~=0 then
			last=#t+1-i
			break
		end
	end
	for i=1,#t do
		if f[i]()~=0 then
			if t[i]:GetCount()+1==math.abs(f[i]()) and i==last then
				sg:AddCard(c)
				t[i]:AddCard(c)
				local res=f[i](c,tp,eqc) and f[i](t[i],tp,eqc) and Auxiliary.ECheckAnswer(tp,t,equation,...)
				sg:RemoveCard(c)
				t[i]:RemoveCard(c)
				return res
			elseif t[i]:GetCount()<math.abs(f[i]()) then
				sg:AddCard(c)
				t[i]:AddCard(c)
				local res=mg:IsExists(Auxiliary.ECheckLoop,1,sg,tp,t,mg,sg,gf,equation,eqc,...)
				sg:RemoveCard(c)
				t[i]:RemoveCard(c)
				return res
			end
		end
	end
	return false
end
function Auxiliary.ECheckAnswer(tp,t,equation,...)
	local f={...}
	for i=1,#t do
		if f[i](nil)~=0 then
			if t[i]:GetCount()~=math.abs(f[i]()) then
				return false
			end
			if t[i]:FilterCount(f[i],nil,tp,eqc)~=math.abs(f[i]()) then
				return false
			end
			if not f[i](t[i],tp,eqc) then
				return false
			end
		end
	end
	local chk={}
	for i=1,#t do
		if f[i](nil)~=0 then
			table.insert(chk,f[i](t[i],tp,eqc))
		else
			table.insert(chk,0)
		end
	end
	return equation(table.unpack(chk))
end
function Auxiliary.ECheckRecursive(c,tp,mg,sg,gf,equation,eqc,ct,ect,...)
	sg:AddCard(c)
	ct=ct+1
	local res=Auxiliary.ECheckGoal(tp,sg,gf,equation,eqc,...)
		or (ct<ect and mg:IsExists(Auxiliary.ECheckRecursive,1,sg,tp,mg,sg,gf,equation,eqc,ct,ect,...))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function Auxiliary.EIsMMZ(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function Auxiliary.ECheckGoal(tp,sg,gf,equation,eqc,...)
	local f={...}
	local t={}
	for i=1,#f do
		local fg=Group.CreateGroup()
		table.insert(t,fg)
	end
	local g=Group.CreateGroup()
	return (not gf or gf(sg)) and Duel.GetMZoneCount(tp,sg,tp)>0
		and sg:IsExists(Auxiliary.ECheckLoop,1,nil,tp,t,sg,g,gf,equation,eqc,...)
end
function Auxiliary.EquationCondition(gf,equation,...)
	local f={...}
	return function(e,c)
		if c==nil then
			return true
		end
		local tp=c:GetControler()
		local mg=Auxiliary.GetEquationGroup(tp,table.unpack(f))
		local sg=Group.CreateGroup()
		local ect=Auxiliary.GetEquationCount(table.unpack(f))
		return ect>0 and mg:IsExists(Auxiliary.ECheckRecursive,1,sg,tp,mg,sg,gf,equation,c,#sg,ect,table.unpack(f))
	end
end
function Auxiliary.EquationTarget(gf,equation,...)
	local f={...}
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c)
		local mg=Auxiliary.GetEquationGroup(tp,table.unpack(f))
		local sg=Group.CreateGroup()
		local ect=Auxiliary.GetEquationCount(table.unpack(f))
		local finish=false
		while #sg<ect do
			finish=Auxiliary.ECheckGoal(tp,sg,gf,equation,c,table.unpack(f))
			local cg=mg:Filter(Auxiliary.ECheckRecursive,sg,tp,mg,sg,gf,equation,c,#sg,ect,table.unpack(f))
			if #cg==0 then
				break
			end
			local cancel=not finish
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tc=cg:SelectUnselect(sg,tp,finish,cancel,ect,ect)
			if not tc then
				break
			end
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
				if #sg==ect then
					finish=true
				end
			else
				sg:RemoveCard(tc)
			end
		end
		if finish then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			return true
		else
			return false
		end
	end
end
function Auxiliary.EquationOperation(gf,equation,...)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_EQUATION)
		g:DeleteGroup()
	end
end
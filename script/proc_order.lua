TYPE_ORDER=0x10000000
REASON_ORDER=0x40000000
SUMMON_TYPE_ORDER=0x40005000
SUMMON_TYPE_ORDER_L=0x40005010
SUMMON_TYPE_ORDER_R=0x40005020

EFFECT_CANNOT_BE_ORDER_MATERIAL=700
EFFECT_EXTRA_ORDER_MATERIAL=701
EFFECT_MUST_BE_OMATERIAL=702

function aux.ordlimit(e,se,sp,st)
	return st&SUMMON_TYPE_ORDER==SUMMON_TYPE_ORDER
end

function Card.IsOrderSummonable(c)
	return (c:IsSpecialSummonable(SUMMON_TYPE_ORDER_L) or c:IsSpecialSummonable(SUMMON_TYPE_ORDER_R)
		or c:IsSpecialSummonable(SUMMON_TYPE_ORDER))
end

function Card.IsCanBeOrderMaterial(c,ord)
	if c:IsForbidden() then
		return false 
	end
	local eset={c:IsHasEffect(EFFECT_CANNOT_BE_ORDER_MATERIAL)}
	for _,te in pairs(eset) do
		local f=te:GetValue()
		if f==1 then return false end
		if f and f(te,ord) then return false end
	end
	return true
end

function Card.IsOrderMaterialCount(c,count,greater_or_equal_or_less)
	if greater_or_equal_or_less=="Greater" then
		while count<=5 do
			if c:IsHasEffect(99000370+count) then
				return true
			end
			count=count+1
		end
	elseif greater_or_equal_or_less=="Equal" then
		if c:IsHasEffect(99000370+count) then
			return true
		end
	elseif greater_or_equal_or_less=="Less" then
		while count>=1 do
			if c:IsHasEffect(99000370+count) then
				return true
			end
			count=count-1
		end
	else
		return false
	end
end

function Duel.OrderSummon(p,c)
	if not c:IsType(TYPE_ORDER) then
		return false
	else
		Duel.SpecialSummonRule(p,c,c:GetSummonType())
	end
end

--오더 소환 유틸리티

function Auxiliary.AddOrderProcedure(c,dir,gf,...)
	local f={...}
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99000300,4))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.OrderCondition(gf,table.unpack(f)))
	e1:SetTarget(Auxiliary.OrderTarget(gf,table.unpack(f)))
	e1:SetOperation(Auxiliary.OrderOperation(gf,table.unpack(f)))
	if (dir=="L" or dir=="<") then
		e1:SetValue(SUMMON_TYPE_ORDER_L)
	elseif (dir=="R" or dir==">") then
		e1:SetValue(SUMMON_TYPE_ORDER_R)
	else
		e1:SetValue(SUMMON_TYPE_ORDER)
	end
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(99000370+#f)
	c:RegisterEffect(e2)
end
function Auxiliary.OrderConditionFilter(c,ord)
	return (c:GetSequence()<5 or c:IsHasEffect(EFFECT_EXTRA_ORDER_MATERIAL)) and c:IsCanBeOrderMaterial(ord)
end
function Auxiliary.OrderCheckGoal(sg,tp,oc,gf,...)
	local f={...}
	return Duel.GetLocationCountFromEx(tp,tp,sg,oc)>0 and (not gf or gf(sg))
		and sg:IsExists(Auxiliary.OrderStartFilter,1,nil,sg,tp,table.unpack(f))
end
function Auxiliary.OrderCheckFilter(c,sg,f)
	return c and sg:IsContains(c) and (not f or f(c))
end
function Auxiliary.OrderStartFilter(c,sg,tp,...)
	local f={...}
	local seq=aux.GetColumn(c,tp)
	if seq+#f>5 then
		return false
	end
	for i=0,#f-1 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq+i)
		local ec=(seq+i)&1>0 and Duel.GetFieldCard(tp,LOCATION_MZONE,(seq+i+9)/2)
		if not (aux.OrderCheckFilter(tc,sg,f[i+1])
			or aux.OrderCheckFilter(ec,sg,f[i+1])) then
		return false
		end
	end
	return true
end
function Auxiliary.OrderCondition(gf,...)
	local f={...}
	return function(e,c)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		if #f<2 then return false end
		local tp=c:GetControler()
		local mg=Duel.GetMatchingGroup(Auxiliary.OrderConditionFilter,tp,LOCATION_MZONE,0,nil,c)
		local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_OMATERIAL)
		if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
		Duel.SetSelectedCard(fg)
		return mg:CheckSubGroup(Auxiliary.OrderCheckGoal,#f,#f,tp,c,gf,table.unpack(f))
	end
end
function Auxiliary.OrderTarget(gf,...)
	local f={...}
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c)
		local mg=Duel.GetMatchingGroup(Auxiliary.OrderConditionFilter,tp,LOCATION_MZONE,0,nil,c)
		local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_OMATERIAL)
		Duel.SetSelectedCard(fg)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99000300,5))
		local cancel=Duel.IsSummonCancelable()
		local sg=mg:SelectSubGroup(tp,Auxiliary.OrderCheckGoal,cancel,#f,#f,tp,c,gf,table.unpack(f))
		if sg then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			return true
		else
			return false
		end
	end
end
function Auxiliary.OrderOperation(gf,...)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_ORDER)
		local tc=g:GetFirst()
		while tc do
			Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,e,REASON_ORDER,tp,tp,0)
			tc=g:GetNext()
		end
		Duel.RaiseEvent(g,EVENT_BE_MATERIAL,e,REASON_ORDER,tp,tp,0)
		g:DeleteGroup()
	end
end

--융합 타입 삭제

	local type=Card.GetType
	Card.GetType=function(c)
	if c.CardType_Order then
		return bit.bor(type(c),TYPE_FUSION)-TYPE_FUSION
	end
	return type(c)
end
--
	local otype=Card.GetOriginalType
	Card.GetOriginalType=function(c)
	if c.CardType_Order then
		return bit.bor(otype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return otype(c)
end
--
	local ftype=Card.GetFusionType
	Card.GetFusionType=function(c)
	if c.CardType_Order then
		return bit.bor(ftype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ftype(c)
end
--
	local ptype=Card.GetPreviousTypeOnField
	Card.GetPreviousTypeOnField=function(c)
	if c.CardType_Order then
		return bit.bor(ptype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ptype(c)
end
--
	local itype=Card.IsType
	Card.IsType=function(c,t)
	if c.CardType_Order then
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
	if c.CardType_Order then
		if t==TYPE_FUSION then
			return false
		end
		return iftype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return iftype(c,t)
end
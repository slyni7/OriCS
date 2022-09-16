TYPE_MODULE=0x40000000
REASON_MODULE=0x400000
SUMMON_TYPE_MODULE=0x40006000

EFFECT_CANNOT_BE_MODULE_MATERIAL=800
EFFECT_EXTRA_MODULE_MATERIAL=801

EFFECT_ADD_MODULE_CODE=802
EFFECT_ADD_MODULE_SETCODE=803
EFFECT_ADD_MODULE_ATTRIBUTE=804
EFFECT_ADD_MODULE_RACE=805
--EFFECT_ADD_MODULE_LEVEL=806
EFFECT_MUST_BE_MMATERIAL=807

function Card.IsCanBeModuleMaterial(c,mod)
	if c:IsForbidden() then
		return false 
	end
	local eset={c:IsHasEffect(EFFECT_CANNOT_BE_MODULE_MATERIAL)}
	for _,te in pairs(eset) do
		local f=te:GetValue()
		if f==1 then return false end
		if f and f(te,mod) then return false end
	end
	return true
end

function Card.IsModuleSetCard(c,...)
	local setcodes={...}
	if c:IsSetCard(table.unpack(setcodes)) then
		return true
	end
	local eset1={c:IsHasEffect(EFFECT_ADD_MODULE_CODE)}
	for _,te in ipairs(eset1) do
		local f=te:GetValue()
		local code=type(f)=="function" and f(te,c) or f
		local setcard=Duel.ReadCard(code,CARDDATA_SETCODE)
		for _,setcode in ipairs(setcodes) do
			local settype=setcode&0xfff
			local setsubtype=setcode&0xf000
			while setcard>0 do
				if setcard&0xfff==settype and setcard&0xf000&setsubtype==setsubtype then
					return true
				end
				setcard=setcard>>16
			end
		end
	end
	local eset2={c:IsHasEffect(EFFECT_ADD_MODULE_SETCODE)}
	for _,te in ipairs(eset2) do
		local f=te:GetValue()
		local setcard=type(f)=="function" and f(te,c) or f
		for _,setcode in ipairs(setcodes) do
			if setcard==setcode then
				return true
			end
		end
	end
	return false
end

function Card.IsModuleCode(c,...)
	local codes={...}
	if c:IsCode(table.unpack(codes)) then
		return true
	end
	local eset={c:IsHasEffect(EFFECT_ADD_MODULE_CODE)}
	for _,te in ipairs(eset) do
		local f=te:GetValue()
		local v=type(f)=="function" and f(te,c) or f
		for _,code in ipairs(codes) do
			if v==code then
				return true
			end
		end
	end
	return false
end

function Card.IsModuleAttribute(c,att)
	if c:IsAttribute(att) then
		return true
	end
	local eset={c:IsHasEffect(EFFECT_ADD_MODULE_ATTRIBUTE)}
	for _,te in ipairs(eset) do
		local f=te:GetValue()
		local v=type(f)=="function" and f(te,c) or f
		if v&att>0 then
			return true
		end
	end
	return false
end

function Card.IsModuleRace(c,race)
	if c:IsRace(race) then
		return true
	end
	local eset={c:IsHasEffect(EFFECT_ADD_MODULE_RACE)}
	for _,te in ipairs(eset) do
		local f=te:GetValue()
		local v=type(f)=="function" and f(te,c) or f
		if v&race>0 then
			return true
		end
	end
	return false
end

--모듈 소환(룰)
function Auxiliary.AddModuleProcedure(c,f1,f2,min,max,gf)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	if max>5 then
		max=5
	end
	e1:SetCondition(Auxiliary.ModuleCondition(f1,f2,min,max,gf))
	e1:SetTarget(Auxiliary.ModuleTarget(f1,f2,min,max,gf))
	e1:SetOperation(Auxiliary.ModuleOperation(f1,f2,min,max,gf))
	e1:SetValue(SUMMON_TYPE_MODULE)
	c:RegisterEffect(e1)
	local mt=getmetatable(c)
	mt.CardType_Module=true
end
function Auxiliary.ModuleConditionFilter(c,mod,lv,f1,f2)
	if not c:IsCanBeModuleMaterial(mod) then
		return false
	end
	if c:IsLocation(LOCATION_MZONE) and (not f1 or f1(c)) then
		local g=c:GetEquipGroup()
		local eg=not f2 and g or g:Filter(f2,nil)
		return g and not (c:GetLevel()+#eg<lv or c:GetLevel()-#eg>lv)
	else
		local tc=c:GetEquipTarget()
		if not tc then
			return false
		end
		local g=tc:GetEquipGroup()
		local eg=not f2 and g or g:Filter(f2,nil)
		return not (tc:GetLevel()+#eg<lv or tc:GetLevel()-#eg>lv)
	end
end
function Auxiliary.ModuleCheckGoal(sg,tp,f1,f2,gf,mc)
	return Duel.GetLocationCountFromEx(tp,tp,sg,mc)>0 and
		sg:IsExists(Auxiliary.ModuleStartFilter,1,nil,sg,tp,f1,f2,gf,mc)
end
function Auxiliary.ModuleNotEquipFilter(c,ec)
	local g=ec:GetEquipGroup()
	return not g:IsContains(c)
end
function Auxiliary.ModuleStartFilter(c,sg,tp,f1,f2,gf,mc)
	if c:IsLocation(LOCATION_MZONE) and (not f1 or f1(c)) then
		local g=sg:Clone()
		if gf and not gf(g) then
			return false
		end
		g:RemoveCard(c)
		if g:IsExists(Auxiliary.ModuleNotEquipFilter,1,nil,c) then
			return false
		end
		if c:GetLevel()+#g<mc:GetLevel() or c:GetLevel()-#g>mc:GetLevel() then
			return false
		end
		if f2 and g:FilterCount(f2,nil)~=#g then
			return false
		end
		return true
	end
	return false
end
function Auxiliary.ModuleCondition(f1,f2,min,max,gf)
	return function(e,c)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local mg=Duel.GetMatchingGroup(Auxiliary.ModuleConditionFilter,tp,LOCATION_ONFIELD,0,nil,c,c:GetLevel(),f1,f2)
		local tg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_MMATERIAL)
		Duel.SetSelectedCard(tg)
		return mg:CheckSubGroup(Auxiliary.ModuleCheckGoal,min+1,max+1,tp,f1,f2,gf,c)
	end
end
function Auxiliary.ModuleTarget(f1,f2,min,max,gf)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c)
		local mg=Duel.GetMatchingGroup(Auxiliary.ModuleConditionFilter,tp,LOCATION_ONFIELD,0,nil,c,c:GetLevel(),f1,f2)
		local tg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_MMATERIAL)
		Duel.SetSelectedCard(tg)
		local cancel=Duel.GetCurrentChain()==0
		local sg=mg:SelectSubGroup(tp,Auxiliary.ModuleCheckGoal,cancel,min+1,max+1,tp,f1,f2,gf,c)
		if sg then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			return true
		else
			return false
		end
	end
end
function Auxiliary.ModuleOperation(gf,...)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_MODULE)
		local tc=g:GetFirst()
		while tc do
			Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,e,REASON_MODULE,tp,tp,0)
			tc=g:GetNext()
		end
		Duel.RaiseEvent(g,EVENT_BE_MATERIAL,e,REASON_MODULE,tp,tp,0)
		g:DeleteGroup()
	end
end

--융합 타입 삭제 시작
	local type=Card.GetType
	Card.GetType=function(c)
	if c.CardType_Module then
		return bit.bor(type(c),TYPE_FUSION)-TYPE_FUSION
	end
	return type(c)
end
--
	local otype=Card.GetOriginalType
	Card.GetOriginalType=function(c)
	if c.CardType_Module then
		return bit.bor(otype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return otype(c)
end
--
	local ftype=Card.GetFusionType
	Card.GetFusionType=function(c)
	if c.CardType_Module then
		return bit.bor(ftype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ftype(c)
end
--
	local ptype=Card.GetPreviousTypeOnField
	Card.GetPreviousTypeOnField=function(c)
	if c.CardType_Module then
		return bit.bor(ptype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ptype(c)
end
--
	local itype=Card.IsType
	Card.IsType=function(c,t)
	if c.CardType_Module then
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
	if c.CardType_Module then
		if t==TYPE_FUSION then
			return false
		end
		return iftype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return iftype(c,t)
end
--융합 타입 삭제 끝
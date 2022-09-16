dofile("expansions/script/proc_version_check.lua")

function Auxiliary.FilterBoolFunctionEx(f,...)
	local params={...}
	return function(target)
			return f(target,table.unpack(params))
		end
end
function Auxiliary.AddEquipProcedure(c,p,f,eqlimit,cost,tg,op,con)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1068)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	if con then
		e1:SetCondition(con)
	end
	if cost~=nil then
		e1:SetCost(cost)
	end
	e1:SetTarget(Auxiliary.EquipTarget(tg,p,f))
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	if eqlimit~=nil then
		e2:SetValue(eqlimit)
	elseif f then
		e2:SetValue(Auxiliary.EquipLimit(f))
	else
		e2:SetValue(1)
	end
	c:RegisterEffect(e2)
	return e1
end
function Auxiliary.EquipLimit(f)
	return function(e,c)
				return not f or f(c,e,e:GetHandlerPlayer())
			end
end
function Auxiliary.EquipFilter(c,p,f,e,tp)
	return (p==PLAYER_ALL or c:IsControler(p)) and c:IsFaceup() and (not f or f(c,e,tp))
end
function Auxiliary.EquipTarget(tg,p,f)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			local player=nil
			if p==0 then
				player=tp
			elseif p==1 then
				player=1-tp
			elseif p==PLAYER_ALL or p==nil then
				player=PLAYER_ALL
			end
			if chkc then
				return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup()
					and Auxiliary.EquipFilter(chkc,player,f,e,tp)
			end
			if chk==0 then
				return player~=nil and Duel.IsExistingTarget(Auxiliary.EquipFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,player,f,e,tp)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectTarget(tp,Auxiliary.EquipFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,player,f,e,tp)
			if tg then
				tg(e,tp,eg,ep,ev,re,r,rp,g:GetFirst())
			end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetReset(RESET_CHAIN)
			e1:SetLabel(Duel.GetCurrentChain())
			e1:SetLabelObject(e)
			e1:SetOperation(Auxiliary.EquipEquip)
			Duel.RegisterEffect(e1,tp)
			Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
		end
end
function Auxiliary.EquipEquip(e,tp,eg,ep,ev,re,r,rp)
	if re~=e:GetLabelObject() then
		return
	end
	local c=e:GetHandler()
	local tc=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TARGET_CARDS):GetFirst()
	if tc and c:IsRelateToEffect(re) and tc:IsRelateToEffect(re) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function Auxiliary.NonTunerEx(f,a,b,c)
	return function(target,scard,sumtype,tp)
			return target:IsNotTuner(scard,tp) and (not f or f(target,a,b,c))
		end
end
local setcl=Effect.SetCountLimit
global_eff_count_limit_max={}
global_eff_count_limit_code={}
global_eff_count_limit_flag={}
function Effect.SetCountLimit(e,max,code,flag,...)
	if IREDO_COMES_TRUE or YGOPRO_VERSION~="Percy/EDO" then
		if type(code)=="table" then
			code=code[1]+code[2]
		end
		if flag then
			code=code+flag
		end
	else
		if type(flag)=="number" then
			flag=(flag>>28)
		elseif type(code)=="number" then
			local ccode=code&0x8fffffff
			local cflag=code&0x70000000
			if cflag>0 then
				code=ccode
				flag=(cflag>>28)
			elseif ccode==1 then
				code=0
				flag=4
			end
		end
	end
	global_eff_count_limit_max[e]=max
	global_eff_count_limit_code[e]=code
	global_eff_count_limit_flag[e]=flag
	setcl(e,max,code,flag,...)
end
if YGOPRO_VERSION~="Percy/EDO" then
	function Auxiliary.FilterFaceupFunction(f,...)
		local params={...}
		return 	function(target)
					return target:IsFaceup() and f(target,table.unpack(params))
				end
	end
end

function GetID()
	return self_table,self_code
end

dofile("expansions/script/AuxCard_CustomType.lua")
if YGOPRO_VERSION~="Percy/EDO" then
	pcall(dofile,"expansions/script/proc_fusion_koishi.lua")
	pcall(dofile,"expansions/script/proc_synchro_koishi.lua")
	pcall(dofile,"expansions/script/proc_xyz_koishi.lua")
end
pcall(dofile,"expansions/script/proc_equation.lua")
--pcall(dofile,"expansions/script/proc_access.lua")
pcall(dofile,"expansions/script/proc_order.lua")
pcall(dofile,"expansions/script/proc_diffusion.lua")
dofile("expansions/script/proc_beyond.lua")
dofile("expansions/script/proc_square.lua")
dofile("expansions/script/proc_delight.lua")
dofile("expansions/script/proc_scripted.lua")
pcall(dofile,"expansions/script/inf.lua")
dofile("expansions/script/ireina.lua")
pcall(dofile,"expansions/script/BELCH.lua")
pcall(dofile,"expansions/script/mirror.lua")
pcall(dofile,"expansions/script/Spinel.lua")
pcall(dofile,"expansions/script/YuL.lua")
--pcall(dofile,"expansions/script/cyan.lua")
pcall(dofile,"expansions/script/Rune.lua")
pcall(dofile,"expansions/script/hebi.lua")
pcall(dofile,"expansions/script/cirukiru9.lua")
pcall(dofile,"expansions/script/additional_setcards.lua")
pcall(dofile,"expansions/script/remove_xyz_which_have_rank.lua")
pcall(dofile,"expansions/script/kaos.lua")
dofile("expansions/script/SSSS.lua")
local cregeff=Card.RegisterEffect
Auxiliary.MetatableEffectCount=true
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	if c:IsStatus(STATUS_INITIALIZING) and Auxiliary.MetatableEffectCount then
		if not mt.eff_ct then
			mt.eff_ct={}
		end
		if not mt.eff_ct[c] then
			mt.eff_ct[c]={}
		end
		local ct=0
		while true do
			if mt.eff_ct[c][ct]==e then
				break
			end
			if not mt.eff_ct[c][ct] then
				mt.eff_ct[c][ct]=e
				break
			end
			ct=ct+1
		end
	end
	cregeff(c,e,forced,...)
end
--dofile("expansions/script/RDD.lua")
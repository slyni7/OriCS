--[[
KoishiPro :
dofile("expansions/init.lua") >> dofile("expansions/script/OriCS_init.lua")

EDOPro :
Duel.LoadScript("OriCS_init.lua") >> pcall(dofile,"expansions/init.lua")
--]]

if not OriCS_init then
	OriCS_init=true
	if not pcall(dofile,"repositories/OriCS/init.lua") then pcall(dofile,"expansions/init.lua") end
end

--version check
if not YGOPRO_VERSION then
	if EFFECT_FUSION_MAT_RESTRICTION then YGOPRO_VERSION="Percy/EDO"
	elseif EFFECT_CHANGE_LINK_MARKER_KOISHI then YGOPRO_VERSION="Koishi"
	else YGOPRO_VERSION="Core" end
end

--dependencies
if YGOPRO_VERSION~="Percy/EDO" then
	Auxiliary.FilterFaceupFunction=function(f,...)
		local params={...}
		return 	function(target)
					return target:IsFaceup() and f(target,table.unpack(params))
				end
	end
else --Koishi/Core
	Duel.LoadScript = function(s,forced)
		local orics = "repositories/OriCS/script/" .. s
		local corona = "repositories/CP19/script/" .. s
		local exp = "expansions/script/" .. s
		--★차후 forced에 관한 수정 바람
		if not pcall(dofile(orics)) then
			if not pcall(dofile(corona)) then
				pcall(dofile(exp))
			end
		end
	end
	GetID=function()
		return self_table,self_code
	end
	Auxiliary.FilterBoolFunctionEx=function(f,value)
		return	function(target,scard,sumtype,tp)
					return f(target,value,scard,sumtype,tp)
				end
	end
	Auxiliary.FilterBoolFunctionEx2=function(f,...)
		local params={...}
		return	function(target,scard,sumtype,tp)
					return f(target,scard,sumtype,tp,table.unpack(params))
				end
	end
	Auxiliary.AddEquipProcedure=function(c,p,f,eqlimit,cost,tg,op,con)
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
	Auxiliary.EquipLimit=function(f)
		return function(e,c)
					return not f or f(c,e,e:GetHandlerPlayer())
				end
	end
	Auxiliary.EquipFilter=function(c,p,f,e,tp)
		return (p==PLAYER_ALL or c:IsControler(p)) and c:IsFaceup() and (not f or f(c,e,tp))
	end
	Auxiliary.EquipTarget=function(tg,p,f)
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
	Auxiliary.EquipEquip=function(e,tp,eg,ep,ev,re,r,rp)
		if re~=e:GetLabelObject() then
			return
		end
		local c=e:GetHandler()
		local tc=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TARGET_CARDS):GetFirst()
		if tc and c:IsRelateToEffect(re) and tc:IsRelateToEffect(re) and tc:IsFaceup() then
			Duel.Equip(tp,c,tc)
		end
	end
	Auxiliary.NonTunerEx=function(f,a,b,c)
		return function(target,scard,sumtype,tp)
				return target:IsNotTuner(scard,tp) and (not f or f(target,a,b,c))
			end
	end
end

--Effect.SetCountLimit
local setCntLmt=Effect.SetCountLimit
global_eff_count_limit_max={}
global_eff_count_limit_code={}
global_eff_count_limit_flag={}

Effect.SetCountLimit=function(e,max,code,flag,...)
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
	setCntLmt(e,max,code,flag,...)
end

--Card.RegisterEffect
--[[
local cRegEff=Card.RegisterEffect
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
	cRegEff(c,e,forced,...)
end
--]]

--OriCS utilities
Duel.LoadScript("_register_effect.lua");
Duel.LoadScript("AuxCard_CustomType.lua")
if YGOPRO_VERSION~="Percy/EDO" then
	Duel.LoadScript("koishi_proc_fusion.lua")
	Duel.LoadScript("koishi_proc_synchro.lua")
	Duel.LoadScript("koishi_proc_xyz.lua")
end
Duel.LoadScript("proc_equation.lua")
Duel.LoadScript("proc_order.lua")
Duel.LoadScript("proc_diffusion.lua")
Duel.LoadScript("proc_beyond.lua")
Duel.LoadScript("proc_square.lua")
Duel.LoadScript("proc_delight.lua")
Duel.LoadScript("proc_scripted.lua")
Duel.LoadScript("proc_module.lua")
Duel.LoadScript("init_ireina.lua")
Duel.LoadScript("init_Spinel.lua")
Duel.LoadScript("init_YuL.lua")
Duel.LoadScript("init_kaos.lua")
Duel.LoadScript("additional_setcards.lua")
Duel.LoadScript("additional_setcards_expand.lua")


--[[
KoishiPro :
dofile("expansions/init.lua") >> dofile("expansions/script/OriCS_init.lua")

EDOPro :
Duel.LoadScript("OriCS_init.lua") >> pcall(dofile,"expansions/init.lua")
--]]

--version check
if not YGOPRO_VERSION then
	if EFFECT_FUSION_MAT_RESTRICTION then YGOPRO_VERSION="Percy/EDO"
	elseif EFFECT_CHANGE_LINK_MARKER_KOISHI then YGOPRO_VERSION="Koishi"
	else YGOPRO_VERSION="Core" end
	--Debug.Message("init says: Current Version is "..YGOPRO_VERSION)
end

--init
function initScript(s)
	local orics = string.gsub(s, "expansions/", "repositories/OriCS/")
	local corona = string.gsub(s, "expansions/", "repositories/CP19/")
	local _ = pcall(dofile,orics) or pcall(dofile,corona) or pcall(dofile,s)
end
initScript("expansions/convert-from-core/from_core.lua")

--dependencies
if IREDO_COMES_TRUE then
	EFFECT_ADD_FUSION_CODE	=340
	EFFECT_QP_ACT_IN_SET_TURN=359
	EFFECT_COUNT_CODE_OATH	=0x10000000
	EFFECT_COUNT_CODE_DUEL	=0x20000000
	EFFECT_COUNT_CODE_SINGLE=0x1
	OPCODE_ADD				=0x40000000
	OPCODE_SUB				=0x40000001
	OPCODE_MUL				=0x40000002
	OPCODE_DIV				=0x40000003
	OPCODE_AND				=0x40000004
	OPCODE_OR				=0x40000005
	OPCODE_NEG				=0x40000006
	OPCODE_NOT				=0x40000007
	OPCODE_ISCODE			=0x40000100
	OPCODE_ISSETCARD		=0x40000101
	OPCODE_ISTYPE			=0x40000102
	OPCODE_ISRACE			=0x40000103
	OPCODE_ISATTRIBUTE		=0x40000104
	Auxiliary.Stringid=function(code,id)
		return code*16+id
	end
	Card.CanAttack=function(c)
		return c:IsAttackable()
	end
	Card.IsSummonCode=function(c,sc,sumtype,sp,code)
		if sumtype&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION then
			return c:IsFusionCode(code)
		end
		return c:IsCode(code)
	end
	Card.IsGeminiState=Card.IsDualState
	Duel.IsDuelType=aux.FALSE
	OriCS_initialized=true
else
	EFFECT_COUNT_CODE_OATH	=0x10000000
	EFFECT_COUNT_CODE_DUEL	=0x20000000
	EFFECT_COUNT_CODE_SINGLE=0x40000000
	SUMMON_TYPE_ADVANCE=SUMMON_TYPE_TRIBUTE
	if not OriCS_initialized then
		OriCS_initialized=true
		initScript("expansions/script/OriCS_init.lua")
	end
end

--Hand Test
if Duel.GetFieldGroupCount(1,LOCATION_DECK,0)==0 and Duel.IsDuelType(DUEL_ATTACK_FIRST_TURN) then
	local f=io.open("deck/handtest.ydk","r")
	if f==nil then
		return
	end
	local loc=0
	local dt={}
	local et={}
	for line in f:lines() do
		if line=="#main" then
			loc=LOCATION_DECK
		elseif line=="#extra" then
			loc=LOCATION_EXTRA
		elseif line=="!side" then
			loc=0
		elseif loc~=0 then
			local code=tonumber(line)
			if loc==LOCATION_DECK then
				table.insert(dt,code)
			elseif loc==LOCATION_EXTRA then
				table.insert(et,code)
			end
		end
	end
	local ct={}
	local rt={}
	for i=1,#dt do
		while true do
			local rn=Duel.GetRandomNumber(1,#dt)
			if rt[rn]==nil then
				rt[rn]=true
				ct[i]=rn
				break
			end
		end
	end
	for i=1,#dt do
		local code=dt[ct[i]]
		Debug.AddCard(code,1,1,LOCATION_DECK,0,POS_FACEDOWN)
	end
	for i=1,#et do
		local code=et[i]
		Debug.AddCard(code,1,1,LOCATION_EXTRA,0,POS_FACEDOWN)
	end
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,0)
end

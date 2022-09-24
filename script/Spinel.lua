spinel=spinel or {}

--스펠 스피드 조정

GlobalSpellSpeed=false
GlobalSpellSpeedTable={}
GlobalRealTypeTable={}

function Effect.SetSpellSpeed(e,ss)
	GlobalSpellSpeedTable[e]=ss
	if not GlobalSpellSpeed then
		GlobalSpellSpeed=true
		RegisterSpellSpeedCheck()
	end
	GlobalRealTypeTable[e]=e:GetType()
	if ss>1 then
		e:SetType(EFFECT_TYPE_QUICK_O)
	end
end

local egt=Effect.GetType
function Effect.GetType(e)
	if GlobalRealTypeTable[e] then
		return GlobalRealTypeTable[e]
	else
		return egt(e)
	end
end

local eiht=Effect.IsHasType
function Effect.IsHasType(e,type)
	if GlobalRealTypeTable[e] then
		return GlobalRealTypeTable[e]&type>0
	else
		return eiht(e,type)
	end
end

function RegisterSpellSpeedCheck()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if not GlobalSpellSpeedTable[re] and re:IsActiveType(TYPE_COUNTER)
			and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
			GlobalRealTypeTable[re]=EFFECT_TYPE_ACTIVATE
			re:SetType(EFFECT_TYPE_QUICK_O)
			local e1=Effect.GlobalEffect()
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_ACTIVATING)
			e1:SetLabelObject(re)
			e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				GlobalRealTypeTable[re]=nil
				re:SetType(EFFECT_TYPE_ACTIVATE)
				e:Reset()
			end)
			Duel.RegisterEffect(e1,0)
			Duel.SetChainLimitTillChainEnd(function(re,rp,tp)
				return (not GlobalSpellSpeedTable[re] and re:IsActiveType(TYPE_COUNTER)
					and re:IsHasType(EFFECT_TYPE_ACTIVATE))
					or (GlobalSpellSpeedTable[re] and GlobalSpellSpeedTable[re]>2)
			end)
		elseif GlobalSpellSpeedTable[re] and GlobalSpellSpeedTable[re]>2 then
			Duel.SetChainLimitTillChainEnd(function(re,rp,tp)
				return (not GlobalSpellSpeedTable[re] and re:IsActiveType(TYPE_COUNTER)
					and re:IsHasType(EFFECT_TYPE_ACTIVATE))
					or (GlobalSpellSpeedTable[re] and GlobalSpellSpeedTable[re]>2)
			end)
		end
	end)
	Duel.RegisterEffect(e1,0)
end

--소멸

function Duel.Delete(e,sg)	
	local over=Group.CreateGroup()
	if aux.GetValueType(sg)=="Group" then
		local tc=sg:GetFirst()
			while tc do
				if tc:IsLocation(LOCATION_REMOVED) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(0x30)
					tc:RegisterEffect(e1)
				else
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_REMOVE_REDIRECT)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(0x30)
					tc:RegisterEffect(e1)
				end
				local ov=tc:GetOverlayGroup()
				over:Merge(ov)
				tc=sg:GetNext()
			end
		local tg=sg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		sg:Sub(tg)
		Duel.SendtoGrave(over,REASON_RULE)
		Duel.SendtoGrave(tg,REASON_RULE)
		Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
	else
		local ov=sg:GetOverlayGroup()
		over:Merge(ov)
		Duel.SendtoGrave(over,REASON_RULE)
		if sg:IsLocation(LOCATION_REMOVED) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(0x30)
			sg:RegisterEffect(e1)
			Duel.SendtoGrave(sg,REASON_RULE)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMOVE_REDIRECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(0x30)
			sg:RegisterEffect(e1)
			Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
		end
	end
end

--트라미드 아누비스

local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	cregeff(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	--트라미드 마스터
	if code==32912040 and mt.eff_ct[c][0]==e then
		local cost=e:GetCost()
		e:SetCountLimit(999)
		e:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
			local c=e:GetHandler()
			if chk==0 then return c:GetFlagEffect(32912040+1)<1 end
			c:RegisterFlagEffect(32912040+1,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
			return cost(e,tp,eg,ep,ev,re,r,rp,chk)
		end)
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return not Duel.IsPlayerAffectedByEffect(tp,99000347)
		end)
		local ea=e:Clone()
		ea:SetType(EFFECT_TYPE_QUICK_O)
		ea:SetCode(EVENT_FREE_CHAIN)
		ea:SetHintTiming(0,TIMING_END_PHASE)
		ea:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsPlayerAffectedByEffect(tp,99000347)
		end)
		cregeff(c,ea)
		mt.eff_ct[c][2]=ea
	end
	if code==32912040 and mt.eff_ct[c][1]==e then
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsPlayerAffectedByEffect(tp,99000347) or Duel.GetTurnPlayer()~=tp
		end)
	end
	--트라미드 헌터
	if code==95923441 and mt.eff_ct[c][1]==e then
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsPlayerAffectedByEffect(tp,99000347) or Duel.GetTurnPlayer()~=tp
		end)
	end
	--트라미드 댄서
	if code==69529337 and mt.eff_ct[c][0]==e then
		e:SetCountLimit(999)
		e:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
			local c=e:GetHandler()
			if chk==0 then return c:GetFlagEffect(69529337+1)<1 end
			c:RegisterFlagEffect(69529337+1,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
		end)
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return not Duel.IsPlayerAffectedByEffect(tp,99000347)
		end)
		local eb=e:Clone()
		eb:SetType(EFFECT_TYPE_QUICK_O)
		eb:SetCode(EVENT_FREE_CHAIN)
		eb:SetHintTiming(0,TIMING_END_PHASE)
		eb:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsPlayerAffectedByEffect(tp,99000347)
		end)
		cregeff(c,eb)
		mt.eff_ct[c][2]=eb
	end
	if code==69529337 and mt.eff_ct[c][1]==e then
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsPlayerAffectedByEffect(tp,99000347) or Duel.GetTurnPlayer()~=tp
		end)
	end
end

--아스텔라 각성의 빛

local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	cregeff(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	if code==98374133 and mt.eff_ct[c][0]==e then
		e:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and spinel.lightfilter(chkc) end
		if chk==0 then return Duel.IsExistingTarget(spinel.lightfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		Duel.SelectTarget(tp,spinel.lightfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
		end)
	end
	if code==98374133 and mt.eff_ct[c][3]==e then
		e:SetValue(function(e,c)
		local tp=e:GetHandlerPlayer()
		return (c:IsAttribute(ATTRIBUTE_EARTH) or (Duel.GetFlagEffect(tp,99000192)~=0 and c:IsSetCard(0xc21)) or (Duel.GetFlagEffect(tp,99000364)~=0 and c:IsCode(99000355)))
		end)
	end
end
function spinel.lightfilter(c,tp)
	return c:IsFaceup() and (c:IsAttribute(ATTRIBUTE_EARTH) or (Duel.GetFlagEffect(tp,99000192)~=0 and c:IsSetCard(0xc21)) or (Duel.GetFlagEffect(tp,99000364)~=0 and c:IsCode(99000355)))
end


--제로니어 슈퍼특소

--if not ZeronierTable then ZeronierTable={} end

local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	if e:GetCode()==EFFECT_CANNOT_SPECIAL_SUMMON then
		local target=e:GetTarget()
		if target==nil then
			e:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)
				--for i,eff in ipairs(ZeronierTable) do
				--	if eff==se then return false end
				--end
			return Duel.GetFlagEffect(sump,c:GetOriginalCode()+99000351)==0
			end)
		else
			e:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)
				--for i,eff in ipairs(ZeronierTable) do
				--	if eff==re or not target(e,c,sump,sumtype,sumpos,targetp,se) then return false end
				--end
			return target(e,c,sump,sumtype,sumpos,targetp,se)
				and Duel.GetFlagEffect(sump,c:GetOriginalCode()+99000351)==0
			end)
		end
	end
	cregeff(c,e,forced,...)
end

local dregeff=Duel.RegisterEffect
function Duel.RegisterEffect(e,tp,forced,...)
	if e:GetCode()==EFFECT_CANNOT_SPECIAL_SUMMON then
		local target=e:GetTarget()
		if target==nil then
			e:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)
				--for i,eff in ipairs(ZeronierTable) do
				--	if eff==se then return false end
				--end
			return Duel.GetFlagEffect(tp,c:GetOriginalCode()+99000351)==0
			end)
		else
			e:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)
				--for i,eff in ipairs(ZeronierTable) do
				--	if eff==re or not target(e,c,sump,sumtype,sumpos,targetp,se) then return false end
				--end
			return target(e,c,sump,sumtype,sumpos,targetp,se)
				and Duel.GetFlagEffect(tp,c:GetOriginalCode()+99000351)==0
			end)
		end
	end
	dregeff(e,tp,forced,...)
end

--스피넬 슈퍼발동

if not SpinelTable then SpinelTable={} end

local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	if e:GetCode()==EFFECT_CANNOT_ACTIVATE then
		local value=e:GetValue()
		if type(value)~='function' then
			e:SetValue(function(e,re,tp)
				for i,eff in ipairs(SpinelTable) do
				if eff==re then return false end
				end
			return true
			end)
		else
			e:SetValue(function(e,re,tp)
				for i,eff in ipairs(SpinelTable) do
				if eff==re or not value(e,re,tp) then return false end
				end
			return value(e,re,tp)
			end)
		end
	end
	if e:GetCode()==EFFECT_CANNOT_TRIGGER then
		local target=e:GetTarget()
		if target==nil then
			e:SetTarget(function(e,c)
				local code1,code2=c:GetOriginalCodeRule()
				return code1~=99000037 and code2~=99000037 and code1~=99000094 and code2~=99000094 and code1~=99000095 and code2~=99000095
					and code1~=99000096 and code2~=99000096 and code1~=99000097 and code2~=99000097 and code1~=99000098 and code2~=99000098
					and code1~=99000099 and code2~=99000099 and code1~=99000363 and code2~=99000363
			end)
		else
			e:SetTarget(function(e,c)
				local code1,code2=c:GetOriginalCodeRule()
				return target(e,c) and code1~=99000037 and code2~=99000037 and code1~=99000094 and code2~=99000094 and code1~=99000095 and code2~=99000095
					and code1~=99000096 and code2~=99000096 and code1~=99000097 and code2~=99000097 and code1~=99000098 and code2~=99000098
					and code1~=99000099 and code2~=99000099 and code1~=99000363 and code2~=99000363
			end)
		end
	end
	cregeff(c,e,forced,...)
end

local dregeff=Duel.RegisterEffect
function Duel.RegisterEffect(e,tp,forced,...)
	if e:GetCode()==EFFECT_CANNOT_ACTIVATE then
		local value=e:GetValue()
		if type(value)~='function' then
			e:SetValue(function(e,re,tp)
				for i,eff in ipairs(SpinelTable) do
				if eff==re then return false end
				end
			return true
			end)
		else
			e:SetValue(function(e,re,tp)
				for i,eff in ipairs(SpinelTable) do
				if eff==re or not value(e,re,tp) then return false end
				end
			return value(e,re,tp)
			end)
		end
	end
	if e:GetCode()==EFFECT_CANNOT_TRIGGER then
		local target=e:GetTarget()
		if target==nil then
			e:SetTarget(function(e,c)
				local code1,code2=c:GetOriginalCodeRule()
				return code1~=99000037 and code2~=99000037 and code1~=99000094 and code2~=99000094 and code1~=99000095 and code2~=99000095 and code1~=99000096 and code2~=99000096 and code1~=99000097 and code2~=99000097 and code1~=99000098 and code2~=99000098 and code1~=99000099 and code2~=99000099
			end)
		else
			e:SetTarget(function(e,c)
				local code1,code2=c:GetOriginalCodeRule()
				return target(e,c) and code1~=99000037 and code2~=99000037 and code1~=99000094 and code2~=99000094 and code1~=99000095 and code2~=99000095 and code1~=99000096 and code2~=99000096 and code1~=99000097 and code2~=99000097 and code1~=99000098 and code2~=99000098 and code1~=99000099 and code2~=99000099
			end)
		end
	end
	dregeff(e,tp,forced,...)
end

UnlimitChain={}

local dschlim=Duel.SetChainLimit
function Duel.SetChainLimit(f)
	dschlim(function(e,ep,tp)
		for _,te in pairs(UnlimitChain) do
			if e==te then
				return true
			end
		end
		return f(e,ep,tp)
	end)
end

--이하 안쓰는거

--EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP
spinel.delay=0x14000

--엑시즈 소재 제거 (ct=제거할 수)
function spinel.rmovcost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) end
		e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
	end
end

--자기자신 코스트
function spinel.relcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function spinel.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function spinel.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function spinel.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function spinel.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function spinel.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end

--드로우 (pl=플레이어[자신 0, 상대 1], ct=수)
function spinel.drawtg(pl,ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsPlayerCanDraw(math.abs(pl-tp),ct) end
		Duel.SetTargetPlayer(math.abs(pl-tp))
		Duel.SetTargetParam(ct)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,math.abs(pl-tp),ct)
	end
end
function spinel.drawop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--엑시즈 소재수 체크
function spinel.xmcon(ct,excon)
	return function(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=ct and (not excon or excon(e,tp,eg,ep,ev,re,r,rp))
	end
end

--스트링 출력
function spinel.desccost(costf)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return (not costf or costf(e,tp,eg,ep,ev,re,r,rp,0)) end
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		if costf then costf(e,tp,eg,ep,ev,re,r,rp,1) end		
	end
end

--소환타입 체크
function spinel.stypecon(t,con)
	return function(e,tp,eg,ep,ev,re,r,rp)
		return bit.band(e:GetHandler():GetSummonType(),t)==t and (not con or con(e,tp,eg,ep,ev,re,r,rp))
	end
end
--constants
if not CATEGORY_LVCHANGE then
	CATEGORY_LVCHANGE=0x0
end

CARD_TIME_CAPSULE		=11961740
CARD_EINE_KLEINE		=18452775
CARD_DELAYED_IF			=18453397
CARD_HATOTAURUS_TOKEN	=99970687

EFFECT_TIME_CAPSULE		=11961740
EFFECT_EINE_KLEINE		=18452775
EFFECT_LINK_FACEDOWN_SUB=18453034
EFFECT_GEMINI_STAR		=18453157
EFFECT_EXTRA_RITUAL_MATERIAL_CHARLOTTE=18453188
EFFECT_GREED_YOUNGER	=18453229
EFFECT_GREED_SWALLOW	=18453231
EFFECT_GREED_OLDER		=18453233
EFFECT_ALICE_SCARLET	=18453385
EFFECT_UNPUBLIC			=18453549
EFFECT_THE_PHANTOM		=18453590
EFFECT_HATOTAURUS_TOKEN	=99970687

EVENT_OLDGOD_FORCED		=18453128
EVENT_ATTRIBUTE_CHANGE	=EVENT_CUSTOM+18452940

FLAG_EFFECT_ATTRIBUTE	=18452940
FLAG_EFFECT_OLDGOD		=18453128
FLAG_EFFECT_GEMINI		=18453156

RACE_ALCHEMIST			=0x10000000

RESETS_STANDARD_DISABLE	=RESETS_STANDARD+RESET_DISABLE

--globals
GlobalArcanaFortune=false
GlobalAttributeEvent=false
--GlobalVirusRelease=nil

--fractions
Auxiliary.FractionDrawTable={}
Auxiliary.FractionDrawTable[0]={}
Auxiliary.FractionDrawTable[1]={}
Auxiliary.FractionDrawn={}
Auxiliary.FractionDrawn[0]=0
Auxiliary.FractionDrawn[1]=0
function gcd(m,n)
	while n~=0 do
		local q=m
		m=n
		n=q%n
	end
	return m
end
function divide(m,n)
	if n==0 then
		return 99999999
	end
	local d=0
	while m>=n do
		m=m-n
		d=d+1
	end
	return d
end
function lcm(m,n)
	return (m~=0 and n~=0) and divide(m*n,gcd(m,n)) or 0
end
function Duel.FractionDraw(player,amount,reason)
	table.insert(Auxiliary.FractionDrawTable[player],amount)
	local numera=0
	local denomi=0
	for i=1,#Auxiliary.FractionDrawTable[player] do
		local t=Auxiliary.FractionDrawTable[player][i]
		if denomi==0 then
			denomi=t[2]
		else
			denomi=lcm(denomi,t[2])
		end
	end
	for i=1,#Auxiliary.FractionDrawTable[player] do
		local t=Auxiliary.FractionDrawTable[player][i]
		local dd=divide(denomi,t[2])
		numera=numera+t[1]*dd
	end
	local proper=divide(numera,denomi)
	--Debug.Message(proper.." and "..(numera-proper*denomi).."/"..denomi)
	if proper>Auxiliary.FractionDrawn[player] then
		local drawn=Duel.Draw(player,proper-Auxiliary.FractionDrawn[player],reason)
		Auxiliary.FractionDrawn[player]=proper
		return drawn
	else
		return true
	end
end

--common functions
function Auxiliary.FindFunction(x)
	local f=_G
	for v in x:gmatch("[^%.]+") do
		f=f[v]
	end
	return f
end
function Auxiliary.IsMaterialListSetCard(c,setcode)
	if not c.material_setcode then return false end
	if type(c.material_setcode)=='table' then
		for i,scode in ipairs(c.material_setcode) do
			if type(scode)=='string' then
				if setcode==scode then return true end
			else
				if setcode&0xfff==scode&0xfff and setcode&scode==setcode then return true end
			end
		end
	else
		if type(c.material_setcode)=='string' or type(setcode)=='string' then
			return setcode==c.material_setcode
		else
			return setcode&0xfff==c.material_setcode&0xfff and setcode&c.material_setcode==setcode
		end
	end
	return false
end
function Card.AddMonsterAttributeComplete(c)

end
function Card.IsNotCode(c,...)
	return not c:IsCode(...)
end
if not Duel.Exile then
	function Duel.Exile(g,r)
		return Duel.SendtoDeck(g,nil,-2,r)
	end
end
if not Duel.HintActivation then
	function Duel.HintActivation(te)
		Duel.Hint(HINT_CARD,0,te:GetHandler():GetCode())
	end
end

--Link Facedown Utilities
function Auxiliary.LinkFacedownSubFilter(c)
	return c:IsType(TYPE_LINK) and not c:IsType(TYPE_TOKEN) and c:IsHasEffect(EFFECT_LINK_FACEDOWN_SUB)
end
local cits=Card.IsCanTurnSet
function Card.IsCanTurnSet(c)
	if Auxiliary.LinkFacedownSubFilter(c) then
		return true
	end
	return cits(c)
end
local dcp=Duel.ChangePosition
function Duel.ChangePosition(...)
	local t={...}
	local sg
	if aux.GetValueType(t[1])=="Card" then
		sg=Group.FromCards(t[1])
	end
	if aux.GetValueType(t[1])=="Group" then
		sg=t[1]:Clone()
	end
	local fg=sg:Filter(Auxiliary.LinkFacedownSubFilter,nil)
	if #fg>0 and t[2]==POS_FACEDOWN_DEFENSE then
		Duel.Remove(fg,POS_FACEDOWN,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		sg:Sub(og)
	end
	t[1]=sg
	return dcp(table.unpack(t))
end

--Square Utilities
local cict=Card.IsCustomType
function Card.IsCustomType(c,ct)
	if ct&CUSTOMTYPE_SQUARE and c:IsCode(18452829,18452830,18452856,18452977) then
		return true
	end
	return cict(c,ct)
end
if not Effect.SetActiveEffect then
	function Effect.SetActiveEffect()
		return
	end
end

--Melancholic utilites & overrides
function Auxiliary.MelancholicOwnerFilter(c,tp)
	return c:GetOwner()==tp
end
local ddraw=Duel.Draw
function Duel.Draw(tp,ct,r)
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_GREED_YOUNGER) then
		local g=Duel.GetDecktopGroup(tp,ct)
		Duel.DisableShuffleCheck()
		local d=Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.DisableShuffleCheck(false)
		return d
	end
	return ddraw(tp,ct,r)
end
local dipcd=Duel.IsPlayerCanDraw
function Duel.IsPlayerCanDraw(tp,ct)
	if ct and Duel.IsPlayerAffectedByEffect(tp,EFFECT_GREED_YOUNGER) then
		local g=Duel.GetDecktopGroup(tp,ct)
		return g:FilterCount(Card.IsAbleToHand,nil)==ct
	end
	return dipcd(tp,ct)
end
local dsth=Duel.SendtoHand
function Duel.SendtoHand(g,tp,r)
	local sg
	if aux.GetValueType(g)=="Card" then
		sg=Group.FromCards(g)
	end
	if aux.GetValueType(g)=="Group" then
		sg=g:Clone()
	end
	local ct=#sg
	if not tp then
		local g0=sg:Filter(Auxiliary.MelancholicOwnerFilter,nil,0)
		local g1=sg:Filter(Auxiliary.MelancholicOwnerFilter,nil,1)
		if Duel.IsPlayerAffectedByEffect(0,18452752)
			and Duel.IsPlayerAffectedByEffect(0,EFFECT_GREED_YOUNGER)
			and Duel.IsPlayerCanDraw(0) then
			sg:Sub(g0)
			Duel.Draw(0,#g0,REASON_EFFECT)
		end
		if Duel.IsPlayerAffectedByEffect(1,18452752)
			and Duel.IsPlayerAffectedByEffect(1,EFFECT_GREED_YOUNGER)
			and Duel.IsPlayerCanDraw(1) then
			sg:Sub(g1)
			Duel.Draw(1,#g1,REASON_EFFECT)
		end
		if #sg>0 then
			dsth(g,nil,r)
		end
		return ct
	else
		if Duel.IsPlayerAffectedByEffect(tp,18452752)
			and Duel.IsPlayerAffectedByEffect(tp,EFFECT_GREED_YOUNGER)
			and Duel.IsPlayerCanDraw(tp) then
			return Duel.Draw(tp,ct,REASON_EFFECT)
		else
			return dsth(g,tp,r)
		end
	end
end

--Charlotte overrides
local dgritmat=Duel.GetRitualMaterial
function Duel.GetRitualMaterial(p)
	local g=dgritmat(p)
	local cg=Duel.GetMatchingGroup(Card.IsHasEffect,p,0,LOCATION_MZONE,nil,EFFECT_EXTRA_RITUAL_MATERIAL_CHARLOTTE)
	g:Merge(cg)
	return g
end
local cgritlev=Card.GetRitualLevel
function Card.GetRitualLevel(c,rc)
	local lv=cgritlev(c,rc)
	if lv>0 then
		return lv
	end
	local eset={c:IsHasEffect(EFFECT_RITUAL_LEVEL)}
	for _,te in ipairs(eset) do
		local val=te:GetValue()
		if val and val(te,rc)>0 then
			return val(te,rc)
		end
	end
	return 0
end

--common overrides
local gid=GetID
EDOCard={}
function GetID(...)
	local s,id=gid(...)
	EDOCard[id]=true
	return gid(...)
end
local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)
	if e:IsHasType(EFFECT_TYPE_SINGLE) and (e:GetCode()==EFFECT_TRAP_ACT_IN_HAND or e:GetCode()==EFFECT_QP_ACT_IN_NTPHAND)
		and e:IsHasProperty(EFFECT_FLAG_INITIAL) and not e:IsHasProperty(EFFECT_FLAG_CANNOT_DISABLE) then
		local prop=e:GetProperty()
		e:SetProperty(prop|EFFECT_FLAG_CANNOT_DISABLE)
	end
end
local ccopyeff=Card.CopyEffect
function Card.CopyEffect(c,code,...)
	Auxiliary.CopyingCode=code
	local res=ccopyeff(c,code,...)
	Auxiliary.CopyingCode=nil
	return res
end
local cisc=Card.IsSetCard
Auxiliary.ChopinEtudeSetCode=nil
function Card.IsSetCard(c,...)
	local setcode=Auxiliary.ChopinEtudeSetCode
	if setcode then
		return cisc(c,setcode)
	end
	return cisc(c,...)
end
--[[
local cit=Card.IsType
function Card.IsType(c,typ)
	--if typ&TYPE_FIELD==TYPE_FIELD and c:IsType(TYPE_TRAP) then
	--	return cit(c,typ&(~TYPE_FIELD))
	--end
	return cit(c,typ)
end
--]]
local dtc=Duel.TossCoin
function Duel.TossCoin(p,ev)
	local c1,c2,c3,c4,c5=dtc(p,ev)
	if GlobalArcanaFortune then
		GlobalArcanaFortune=false
		c1=1-c1
	end
	return c1,c2,c3,c4,c5
end
local dgcc=Duel.GetCurrentChain
Auxiliary.CheckDisSumAble=false
function Duel.GetCurrentChain()
	if Auxiliary.CheckDisSumAble and dgcc()>0 then
		return dgcc()-1
	end
	return dgcc()
end
Auxiliary.DelayedChainInfo={}
local dgci=Duel.GetChainInfo
function Duel.GetChainInfo(ch,...)
	if ch==0 then
		local ce=dgci(0,CHAININFO_TRIGGERING_EFFECT)
		if Auxiliary.DelayedChainInfo[ce]~=nil then
			local infos={}
			for _,ci in pairs({...}) do
				table.insert(infos,Auxiliary.DelayedChainInfo[ce][ci])
			end
			return table.unpack(infos)
		end
	end
	return dgci(ch,...)
end
local dgft=Duel.GetFirstTarget
function Duel.GetFirstTarget(...)
	local ce=dgci(0,CHAININFO_TRIGGERING_EFFECT)
	if Auxiliary.DelayedChainInfo[ce]~=nil then
		local tg=Auxiliary.DelayedChainInfo[ce][CHAININFO_TARGET_CARDS]
		return tg:GetFirst()
	end
	return dgft(...)
end
function Auxiliary.ChainDelay(effect)
	local ce=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
	local card=ce:GetHandler()
	if card:IsRelateToEffect(ce) then
		card:CreateEffectRelation(effect)
	end
	Auxiliary.DelayedChainInfo[effect]={}
	for i=0,23 do
		local ci=1<<i
		if ci==CHAININFO_TRIGGERING_EFFECT then
			Auxiliary.DelayedChainInfo[effect][ci]=effect
		else
			if type(Duel.GetChainInfo(0,ci))=="Group" then
				local g=Duel.GetChainInfo(0,ci):Clone()
				g:KeepAlive()
				Auxiliary.DelayedChainInfo[effect][ci]=g
				local tc=g:GetFirst()
				while tc do
					if tc:IsRelateToEffect(ce) then
						tc:CreateEffectRelation(effect)
					end
					tc=g:GetNext()
				end
			else
				Auxiliary.DelayedChainInfo[effect][ci]=Duel.GetChainInfo(0,ci)
			end
		end
	end
end

Auxiliary.TriggeringEffect=nil
local est=Effect.SetTarget
function Effect.SetTarget(e,tg)
	if e:IsHasType(EFFECT_TYPE_ACTIONS) then
		local tgf=function(...)
			local t={...}
			Auxiliary.TriggeringEffect=t[1]
			local res=tg(...)
			Auxiliary.TriggeringEffect=nil
			return res
		end
		est(e,tgf)
	else
		est(e,tg)
	end
end
local cixs=Card.IsXyzSummonable
function Card.IsXyzSummonable(...)
	local ce=dgci(0,CHAININFO_TRIGGERING_EFFECT)
	if not ce then
		ce=Auxiliary.TriggeringEffect
	end
	if not ce then
		return cixs(...)
	end
	local id=ce:GetHandler():GetOriginalCode()
	if EDOCard[id] then
		return cixs(...)
	else
		local t={...}
		local c=t[1]
		local a=t[2]
		local b=t[3]
		local d=t[4]
		if d then
			return cixs(c,nil,a,b,d)
		elseif a and not b then
			return cixs(c,nil,a)
		else
			return cixs(...)
		end
	end
end
local dxs=Duel.XyzSummon
function Duel.XyzSummon(...)
	local ce=dgci(0,CHAININFO_TRIGGERING_EFFECT)
	if not ce then
		ce=Auxiliary.TriggeringEffect
	end
	if not ce then
		return dxs(...)
	end
	local id=ce:GetHandler():GetOriginalCode()
	if EDOCard[id] then
		return dxs(...)
	else
		local t={...}
		local p=t[1]
		local c=t[2]
		local a=t[3]
		local b=t[4]
		if not a and b then
			return dxs(p,c,nil,b,1,99)
		elseif a and not b then
			return dxs(p,c,nil,a)
		else
			return dxs(...)
		end
	end
end

--릿카는 빠르다
Auxiliary.IreinaCurrentXyzHandler=nil
function Auxiliary.WriteIreinaEffect(e,i,s)
	local c=e:GetOwner()
	if not c then
		c=Auxiliary.IreinaCurrentXyzHandler
	end
	local code=c:GetOriginalCode()
	if Auxiliary.CopyingCode then
		code=Auxiliary.CopyingCode
	end
	if string.find(s,"N") then
		local x=string.format("%s%s%s%s","c",tostring(code),".con",tostring(i))
		local f=aux.FindFunction(x)
		local n=function(f)
			return function(e,tp,eg,ep,ev,re,r,rp)
				return f(e,tp,eg,ep,ev,re,r,rp)
			end
		end
		e:SetCondition(n(f))
	end
	if string.find(s,"C") then
		local x=string.format("%s%s%s%s","c",tostring(code),".cost",tostring(i))
		local f=aux.FindFunction(x)
		local c=function(f)
			return function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					return f(e,tp,eg,ep,ev,re,r,rp,chk)
				end
				f(e,tp,eg,ep,ev,re,r,rp,chk)
			end
		end
		e:SetCost(c(f))
	end
	if string.find(s,"T") then
		local x=string.format("%s%s%s%s","c",tostring(code),".tar",tostring(i))
		local f=aux.FindFunction(x)
		local t=function(f)
			return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then
					return f(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				end
				if chk==0 then
					return f(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				end
				f(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			end
		end
		e:SetTarget(t(f))
	end
	if string.find(s,"O") then
		local x=string.format("%s%s%s%s","c",tostring(code),".op",tostring(i))
		local f=aux.FindFunction(x)
		local o=function(f)
			return function(e,tp,eg,ep,ev,re,r,rp)
				f(e,tp,eg,ep,ev,re,r,rp)
			end
		end
		e:SetOperation(o(f))
	end	
end
function WriteEff(...)
	return aux.WriteIreinaEffect(...)
end
function Auxiliary.MakeIreinaEffect(c,t,r)
	local e=Effect.CreateEffect(c)
	if Auxiliary.EffTypStrToNum(t)&EFFECT_TYPE_XMATERIAL~=0 then
		Auxiliary.IreinaCurrentXyzHandler=c
	end
	e:SetT(t)
	if r then
		e:SetR(r)
	end
	return e
end
function MakeEff(...)
	return aux.MakeIreinaEffect(...)
end
function Auxiliary.EffTypStrToNum(str)
	local num=0
	if string.find(str,"S") then
		num=num+0x1
	end
	if string.find(str,"F") then
		num=num+0x2
	end
	if string.find(str,"E") then
		num=num+0x4
	end
	if string.find(str,"A") then
		num=num+0x10
	end
	if string.find(str,"R") then
		num=num+0x20
	end
	if string.find(str,"I") then
		num=num+0x40
	end
	if string.find(str,"To") then
		num=num+0x80
	end
	if string.find(str,"Qo") then
		num=num+0x100
	end
	if string.find(str,"Tf") then
		num=num+0x200
	end
	if string.find(str,"Qf") then
		num=num+0x400
	end
	if string.find(str,"C") then
		num=num+0x800
	end
	if string.find(str,"X") then
		num=num+0x1000
	end
	if string.find(str,"G") then
		num=num+0x2000
	end
	return num
end
function Effect.SetT(e,s)
	local n=aux.EffTypStrToNum(s)
	Effect.SetType(e,n)
end
function Auxiliary.LocStrToNum(str)
	if type(str)=="number" then
		return str
	end
	local num=0
	if string.find(str,"D") then
		num=num|0x1
	end
	if string.find(str,"H") then
		num=num|0x2
	end
	if string.find(str,"M") then
		num=num|0x4
	end
	if string.find(str,"S") then
		num=num|0x8
	end
	if string.find(str,"O") then
		num=num|0xc
	end
	if string.find(str,"G") then
		num=num|0x10
	end
	if string.find(str,"R") then
		num=num|0x20
	end
	if string.find(str,"E") then
		num=num|0x40
	end
	if string.find(str,"X") then
		num=num|0x80
	end
	if string.find(str,"F") then
		num=num|0x100
	end
	if string.find(str,"P") then
		num=num|0x200
	end
	return num
end
function LSTN(str)
	return aux.LocStrToNum(str)
end
function Effect.SetR(e,s)
	local n=LSTN(s)
	Effect.SetRange(e,n)
end
function Effect.SetTR(e,s,o)
	local sloc,oloc=LSTN(s),LSTN(o)
	Effect.SetTargetRange(e,sloc,oloc)
end
function Card.IsNotImmuneToEffect(c,e)
	return not c:IsImmuneToEffect(e)
end
function Card.IsNotDisabled(c)
	return not c:IsDisabled()
end
function Card.IsLoc(c,s)
	local n=LSTN(s)
	return Card.IsLocation(c,n)
end
function Duel.GetLocCount(...)
	local t={...}
	t[2]=LSTN(t[2])
	return Duel.GetLocationCount(table.unpack(t))
end
function Duel.SOI(cc,cat,eg,ev,ep,loc)
	Duel.SetOperationInfo(cc,cat,eg,ev,ep,LSTN(loc))
end
function Duel.GMGroup(f,p,s,o,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.GetMatchingGroup(filter(exc),p,sloc,oloc,exg,...)	
end
function Duel.IETarget(f,p,s,o,n,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.IsExistingTarget(filter(exc),p,sloc,oloc,n,exg,...)
end
function Duel.STarget(sp,f,p,s,o,mi,ma,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.SelectTarget(sp,filter(exc),p,sloc,oloc,mi,ma,exg,...)
end
function Duel.IEMCard(f,p,s,o,n,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.IsExistingMatchingCard(filter(exc),p,sloc,oloc,n,exg,...)
end
function Duel.SMCard(sp,f,p,s,o,mi,ma,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.SelectMatchingCard(sp,filter(exc),p,sloc,oloc,mi,ma,exg,...)
end
function Duel.GMFaceupGroup(f,p,s,o,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or f(c,...)) and c:IsFaceup()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.GetMatchingGroup(filter(exc),p,sloc,oloc,exg,...)	
end
function Duel.IEFaceupTarget(f,p,s,o,n,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or f(c,...)) and c:IsFaceup()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.IsExistingTarget(filter(exc),p,sloc,oloc,n,exg,...)
end
function Duel.SFaceupTarget(sp,f,p,s,o,mi,ma,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or f(c,...)) and c:IsFaceup()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_FACEUP)
	return Duel.SelectTarget(sp,filter(exc),p,sloc,oloc,mi,ma,exg,...)
end
function Duel.IEMFaceupCard(f,p,s,o,n,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or f(c,...)) and c:IsFaceup()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.IsExistingMatchingCard(filter(exc),p,sloc,oloc,n,exg,...)
end
function Duel.SMFaceupCard(sp,f,p,s,o,mi,ma,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or f(c,...)) and c:IsFaceup()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_FACEUP)
	return Duel.SelectMatchingCard(sp,filter(exc),p,sloc,oloc,mi,ma,exg,...)
end
function Duel.IEToHandTarget(f,p,s,o,n,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToHand()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.IsExistingTarget(filter(exc),p,sloc,oloc,n,exg,...)
end
function Duel.SAToHandTarget(sp,f,p,s,o,mi,ma,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToHand()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_ATOHAND)
	return Duel.SelectTarget(sp,filter(exc),p,sloc,oloc,mi,ma,exg,...)
end
function Duel.IEMToHandCard(f,p,s,o,n,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToHand()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.IsExistingMatchingCard(filter(exc),p,sloc,oloc,n,exg,...)
end
function Duel.SMAToHandCard(sp,f,p,s,o,mi,ma,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToHand()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_ATOHAND)
	return Duel.SelectMatchingCard(sp,filter(exc),p,sloc,oloc,mi,ma,exg,...)
end
function Duel.IEMToHandMon(f,p,s,o,n,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.IsExistingMatchingCard(filter(exc),p,sloc,oloc,n,exg,...)
end
function Duel.SMAToHandMon(sp,f,p,s,o,mi,ma,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_ATOHAND)
	return Duel.SelectMatchingCard(sp,filter(exc),p,sloc,oloc,mi,ma,exg,...)
end
function Duel.IEMToHandST(f,p,s,o,n,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.IsExistingMatchingCard(filter(exc),p,sloc,oloc,n,exg,...)
end
function Duel.SMAToHandST(sp,f,p,s,o,mi,ma,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_ATOHAND)
	return Duel.SelectMatchingCard(sp,filter(exc),p,sloc,oloc,mi,ma,exg,...)
end
Auxiliary.IreinaSpSumParam={}
SSParam=aux.IreinaSpSumParam
function Auxiliary.SpSumTableToParam(t)
	SSParam[1],SSParam[2],SSParam[4],SSParam[5],SSParam[6],SSParam[7],SSParam[8]
		=t[1],0,false,false,nil,nil,nil
	local i=3
	if type(t[3])=="number" then
		i=4
		SSParam[2]=t[2]
		SSParam[3]=t[3]
	else
		SSParam[3]=t[2]
	end
	if type(t[i])=="table" then
		local j=1
		if type(t[i][1])=="string" then
			j=2
			if find.string("TF") then
				SSParam[4]=true
			end
			if find.string("FT") then
				SSParam[5]=true
			end
			if find.string("TT") then
				SSParam[4],SSParam[5]=true
			end
			local pos=0xf
			if find.string("A") then
				pos=pos&POS_ATTACK
			end
			if find.string("D") then
				pos=pos&POS_DEFENSE
			end
			if find.string("U") then
				pos=pos&POS_FACEUP
			end
			if find.string("S") then
				pos=pos&POS_FACEDOWN
			end
			if find.string("O") then
				SSParam[7]=1-SSParam[3]
			end
			if SSParam[7] then
				if pos<0xf then
					SSParam[6]=pos
				else
					SSParam[6]=POS_FACEUP
				end
			end
		end
		if type(t[i][j])=="number" then
			SSParam[8]=t[i][j]
			if not SSParam[6] then
				SSParam[6]=POS_FACEUP
			end
			if not SSParam[7] then
				SSParam[7]=SSParam[3]
			end
		end
	end
end
function Duel.IEMSpSumCard(f,p,s,o,n,ex,t,...)
	aux.SpSumTableToParam(t)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsCanBeSpecialSummoned(table.unpack(SSParam))
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.IsExistingMatchingCard(filter(exc),p,sloc,oloc,n,exg,...)
end
function Duel.SMSpSumCard(sp,f,p,s,o,mi,ma,ex,t,...)
	aux.SpSumTableToParam(t)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsCanBeSpecialSummoned(table.unpack(SSParam))
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_SPSUMMON)
	return Duel.SelectMatchingCard(sp,filter(exc),p,sloc,oloc,mi,ma,exg,...)
end
function Duel.IESpSumTarget(f,p,s,o,n,ex,t,...)
	aux.SpSumTableToParam(t)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsCanBeSpecialSummoned(table.unpack(SSParam))
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.IsExistingTarget(filter(exc),p,sloc,oloc,n,exg,...)
end
function Duel.SSpSumTarget(sp,f,p,s,o,mi,ma,ex,t,...)
	aux.SpSumTableToParam(t)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsCanBeSpecialSummoned(table.unpack(SSParam))
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_SPSUMMON)
	return Duel.SelectTarget(sp,filter(exc),p,sloc,oloc,mi,ma,exg,...)
end
function Duel.IEMToGraveCard(f,p,s,o,n,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToGrave()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.IsExistingMatchingCard(filter(exc),p,sloc,oloc,n,exg,...)
end
function Duel.SMToGraveCard(sp,f,p,s,o,mi,ma,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToGrave()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_TOGRAVE)
	return Duel.SelectMatchingCard(sp,filter(exc),p,sloc,oloc,mi,ma,exg,...)
end
function Duel.IEToDeckTarget(f,p,s,o,n,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToDeck()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.IsExistingTarget(filter(exc),p,sloc,oloc,n,exg,...)
end
function Duel.SToDeckTarget(sp,f,p,s,o,mi,ma,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToDeck()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_TODECK)
	return Duel.SelectTarget(sp,filter(exc),p,sloc,oloc,mi,ma,exg,...)
end
function Duel.IEMRemoveACCard(f,p,s,o,n,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToRemoveAsCost()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.IsExistingMatchingCard(filter(exc),p,sloc,oloc,n,exg,...)
end
function Duel.SMRemoveACCard(sp,f,p,s,o,mi,ma,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToRemoveAsCost()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_REMOVE)
	return Duel.SelectMatchingCard(sp,filter(exc),p,sloc,oloc,mi,ma,exg,...)
end
function Duel.IEMRemoveCard(f,p,s,o,n,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToRemove()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	return Duel.IsExistingMatchingCard(filter(exc),p,sloc,oloc,n,exg,...)
end
function Duel.SMRemoveCard(sp,f,p,s,o,mi,ma,ex,...)
	local exc=(type(ex)=="number" and ex) or nil
	local exg=((type(ex)=="userdata" or type(ex)=="Card" or type(ex)=="Group") and ex) or nil
	local filter=function(exc)
		return function(c,...)
			return (not f or (f(c,...)
				and (c:IsFaceup() or not c:IsLoc("R"))))
				and c:IsAbleToRemove()
				and (not exc or not c:IsCode(exc))
		end
	end
	local sloc,oloc=LSTN(s),LSTN(o)
	Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_REMOVE)
	return Duel.SelectMatchingCard(sp,filter(exc),p,sloc,oloc,mi,ma,exg,...)
end
function Duel.SPOI(cc,cat,eg,ev,ep,loc)
	Duel.SetPossibleOperationInfo(cc,cat,eg,ev,ep,LSTN(loc))
end

--힘세고 강한 후부키 토큰
local dipcssm=Duel.IsPlayerCanSpecialSummonMonster
function Duel.IsPlayerCanSpecialSummonMonster(...)
	local t={...}
	local p=t[1]
	local eset={Duel.IsPlayerAffectedByEffect(p,EFFECT_HATOTAURUS_TOKEN)}
	local code=t[2]
	if #eset>0 and Duel.ReadCard(code,CARDDATA_TYPE)&TYPE_TOKEN>0 then
		t[2]=CARD_HATOTAURUS_TOKEN
		t[3]=0x0
		t[4]=TYPE_MONSTER|TYPE_NORMAL|TYPE_TOKEN
		t[5]=3000
		t[6]=3000
		t[7]=8
		t[8]=RACE_BEASTWARRIOR
		t[9]=ATTRIBUTE_DARK
		return dipcssm(table.unpack(t))
	else
		return dipcssm(...)
	end
end
local dcretok=Duel.CreateToken
function Duel.CreateToken(...)
	local t={...}
	local p=t[1]
	local eset={Duel.IsPlayerAffectedByEffect(p,EFFECT_HATOTAURUS_TOKEN)}
	local code=t[2]
	if #eset>0 and Duel.ReadCard(code,CARDDATA_TYPE)&TYPE_TOKEN>0 then
		t[2]=CARD_HATOTAURUS_TOKEN
		local tc=dcretok(table.unpack(t))
		for _,te in pairs(eset) do
			local op=te:GetOperation()
			op(tc)
		end
		return tc
	else
		return dcretok(...)
	end
end

--Arcana Force Utilities
ArcanaForceTarotCard={62892347,
8396952,
82710001,
35781051,
61175706,
82710002,
97574404,
34568403,
82710003,
82710004,
82710005,
82710006,
82710007,
82710008,
60953118,
82710009,
82710010,
82710013,
97452817,
82710014,
82710021,
23846921}
function Auxiliary.IsArcanaListed(c)
	return c:IsCode(36690018,73206827,82710015,82710016,82710017,82710018,82710019,82710020,82710021,99189322)
end
function Auxiliary.IsArcanaNumber(c)
	if c:IsSetCard(0x5) then
		if c:IsCode(5861892,69831560) then
			return 10
		end
		for i=1,#ArcanaForceTarotCard do
			if c:IsCode(ArcanaForceTarotCard[i]) then
				return i-1
			end
		end
	end
	return false
end
function Auxiliary.IsArcanaCard(c)
	return c:IsSetCard(0x5) or c:IsCode(6150044,64454614,82710016,99189322)
end

--Alchemist Utilities
function Auxiliary.RegisterAttributeEvent(c)
	if GlobalAttributeEvent then
		return
	end
	GlobalAttributeEvent=true
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_ADJUST)
	ge1:SetOperation(Auxiliary.AttributeEventOperation)
	Duel.RegisterEffect(ge1,0)
end
function Auxiliary.AttributeEventOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ag=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(FLAG_EFFECT_ATTRIBUTE)<1 then
			tc:RegisterFlagEffect(FLAG_EFFECT_ATTRIBUTE,RESET_EVENT+RESETS_STANDARD,0,0)
			tc:SetFlagEffectLabel(FLAG_EFFECT_ATTRIBUTE,tc:GetAttribute())
		elseif tc:GetFlagEffectLabel(FLAG_EFFECT_ATTRIBUTE)~=tc:GetAttribute() then
			tc:SetFlagEffectLabel(FLAG_EFFECT_ATTRIBUTE,tc:GetAttribute())
			ag:AddCard(tc)
		end
		tc=g:GetNext()
	end
	if #ag>0 then
		Duel.RaiseEvent(ag,EVENT_ATTRIBUTE_CHANGE,e,0,0,0,0)
	end
end

--Angel Notes Utilities
function Auxiliary.AngelNotesCantabileFilter(c,tc)
	local eset={c:IsHasEffect(76859168)}
	for _,te in ipairs(eset) do
		if not tc:IsImmuneToEffect(te) then
			return true
		end
	end
	return false
end
function Auxiliary.AngelNotesQuickFilter(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_QUICKPLAY)
end
function Auxiliary.AngelNotesCantabileOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(aux.AngelNotesCantabileFilter,tp,LOCATION_DECK,0,nil,c)
	local sg=Duel.GetMatchingGroup(aux.AngelNotesQuickFilter,tp,LOCATION_DECK,0,nil)
	if #cg>0 and #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(76859118,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local cc=cg:Select(tp,1,1,nil)
		Duel.SendtoGrave(cc,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sc=sg:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
		if #sc>0 then
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if #dg>0 then
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
		return true
	end
	return false
end

--Eine Kleine Utilities

--Silent Majority Utilities
GlobalSilentMajority=nil
function Auxiliary.RegisterSilentMajority()
	if GlobalSilentMajority then
		return
	end
	GlobalSilentMajority=true
	SilentMajorityList={18453084,18453085,18453086,18453087,18453088,18453089,18453090,18453091,18453092,18453093,18453094,
		18453095,18453096,18453097,18453098,18453099,18453100}
	local ge1=Effect.GlobalEffect()
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_ADJUST)
	ge1:SetOperation(Auxiliary.SilentMajorityOperation)
	Duel.RegisterEffect(ge1,0)
end
function Auxiliary.SilentMajorityOperation(e,tp,eg,ep,ev,re,r,rp)
	if not SilentMajorityGroups then
		SilentMajorityGroups={}
		for p=0,1 do
			SilentMajorityGroups[p]=Group.CreateGroup()
			SilentMajorityGroups[p]:KeepAlive()
		end
		for p=0,1 do
			for i=1,#SilentMajorityList do
				local code=SilentMajorityList[i]
				local token=Duel.CreateToken(p,code)
				SilentMajorityGroups[p]:AddCard(token)
			end
		end
		for p=0,1 do
			local ge1=Effect.GlobalEffect()
			ge1:SetType(EFFECT_TYPE_FIELD)
			ge1:SetCode(EFFECT_SPSUMMON_PROC_G)
			ge1:SetRange(LOCATION_MZONE)
			ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ge1:SetValue(SUMMON_TYPE_LINK)
			ge1:SetCountLimit(1,18453098)
			ge1:SetDescription(aux.Stringid(18453098,0))
			ge1:SetCondition(Auxiliary.SilentMajorityLinkCondition1)
			ge1:SetOperation(Auxiliary.SilentMajorityLinkOperation1)
			local ge2=Effect.GlobalEffect()
			ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			ge2:SetTargetRange(LOCATION_MZONE,0)
			ge2:SetLabelObject(ge1)
			Duel.RegisterEffect(ge2,p)
		end
	end
	for p=0,1 do
		for i=1,#SilentMajorityList do
			local code=SilentMajorityList[i]
			local tg=SilentMajorityGroups[p]:Filter(function(c,code) return c:GetOriginalCode()==code end,nil,code)
			local tc=tg:GetFirst()
			if not tc then
				local token=Duel.CreateToken(p,code)
				SilentMajorityGroups[p]:AddCard(token)
			elseif tc:GetLocation()~=0 then
				SilentMajorityGroups[p]:RemoveCard(tc)
				local token=Duel.CreateToken(p,code)
				SilentMajorityGroups[p]:AddCard(token)
			end
		end
	end
end
function Auxiliary.LCheckSilentGoal(sg,tp,lc,gf,lmat)
	return sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),#sg,#sg)
		and Duel.GetMZoneCount(tp,sg,tp)>0 and (not gf or gf(sg))
		and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function Auxiliary.SilentMajorityLinkCondition1(e,c,og)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local lg=SilentMajorityGroups[tp]:Filter(function(c) return c:GetOriginalCode()==18453098 end,nil)
	local lc=lg:GetFirst()
	if not lc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) then
		return false
	end
	local f=aux.FilterBoolFunction(Card.IsLinkSetCard,0x2e0)
	local mg=Auxiliary.GetLinkMaterials(tp,f,lc)
	if not Auxiliary.LConditionFilter(c,f,lc) then
		return false
	end
	mg:AddCard(c)
	local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
	if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then
		return false
	end
	Duel.SetSelectedCard(fg)
	return mg:CheckSubGroup(Auxiliary.LCheckSilentGoal,minc,maxc,tp,lc,nil,c)
end
function Auxiliary.SilentMajorityLinkOperation1(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local lg=SilentMajorityGroups[tp]:Filter(function(c) return c:GetOriginalCode()==18453098 end,nil)
	local lc=lg:GetFirst()
	local mg=Auxiliary.GetLinkMaterials(tp,f,lc)
	mg:AddCard(c)
	local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
	Duel.SetSelectedCard(fg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local cancel=Duel.IsSummonCancelable()
	local tg=mg:SelectSubGroup(tp,Auxiliary.LCheckSilentGoal,cancel,1,1,tp,lc,nil,c)
	if not tg then
		return
	end
	sg:AddCard(lc)
	SilentMajorityGroups[tp]:RemoveCard(lc)
	--Auxiliary.LExtraMaterialCount(tg,lc,tp)
	Duel.SendtoGrave(tg,REASON_MATERIAL+REASON_LINK)
end
if IREDO_COMES_TRUE or (YGOPRO_VERSION~="Core") then
	Auxiliary.RegisterSilentMajority()
end

--Old God Utilities
Auxiliary.oldgod_codes={5257687,70307656,78636495,39180960,75285069,4035199,31242786,2792265,7914843,44913552,18453130}
function Auxiliary.OldGodCost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	c:RegisterFlagEffect(FLAG_EFFECT_OLDGOD,RESET_EVENT+0x1ec0000,0,0)
end
function Auxiliary.OldGodCost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(FLAG_EFFECT_OLDGOD)<1
	end
	c:RegisterFlagEffect(FLAG_EFFECT_OLDGOD,RESET_EVENT+0x1ec0000,0,0)
end

--Gemini Star Utilities
function Auxiliary.GeminiStarValue(e,c)
	local tp=e:GetHandlerPlayer()
	return 0,0x1f,0xff00ff,#{Duel.IsPlayerAffectedByEffect(tp,EFFECT_GEMINI_STAR)}
end
function Auxiliary.GeminiStarOperation(e,tp,turncount)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,c:GetCode())
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_GEMINI_STAR)
	e1:SetReset(RESET_PHASE+PHASE_END,turncount)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetFlagEffect(tp,FLAG_EFFECT_GEMINI)==0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e2:SetDescription(aux.Stringid(18453156,0))
		e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e2:SetTarget(Auxiliary.TargetBoolFunction(Card.IsSetCard,"제미니:"))
		e2:SetValue(Auxiliary.GeminiStarValue)
		Duel.RegisterEffect(e2,tp)
		Duel.RegisterFlagEffect(tp,FLAG_EFFECT_GEMINI,0,0,0)
	end
end
function Auxiliary.ReverseDualNormalCondition(effect)
	local c=effect:GetHandler()
	return c:IsFaceup() and c:IsDualState()
end
function Auxiliary.EnableReverseDualAttribute(c)
	if not EFFECT_DUAL_SUMMONABLE then
		EFFECT_DUAL_SUMMONABLE=77
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCondition(Auxiliary.ReverseDualNormalCondition)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e3)
end

--Aroma Utilities
GlobalAromaRecover={}
GlobalAromaRecover[0]=false
GlobalAromaRecover[1]=false
local ge1=Effect.GlobalEffect()
ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
ge1:SetCode(EVENT_ADJUST)
ge1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return GlobalAromaRecover[0] or GlobalAromaRecover[1]
end)
ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	GlobalAromaRecover[0]=false
	GlobalAromaRecover[1]=false
end)
Duel.RegisterEffect(ge1,0)
local ge2=ge1:Clone()
ge2:SetCode(EVENT_RECOVER)
Duel.RegisterEffect(ge2,0)


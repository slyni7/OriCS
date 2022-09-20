function Auxiliary.IsArcanaListed(c)
	return c:IsCode(36690018,73206827,82710015,82710016,82710017,82710018,82710019,82710020,82710021,99189322)
end
arcana_force_numbering={62892347,8396952,82710001,35781051,61175706,82710002,97574404,34568403,82710003,82710004
	,82710005,82710006,82710007,82710008,60953118,82710009,82710010,82710013,97452817,82710014,82710021,23846921}
function Auxiliary.IsArcanaNumber(c)
	if c:IsSetCard(0x5) then
		if c:IsCode(5861892,69831560) then
			return 10
		end
		for i=1,#arcana_force_numbering do
			if c:IsCode(arcana_force_numbering[i]) then
				return i-1
			end
		end
	end
	return false
end
function Auxiliary.IsArcanaCard(c)
	return c:IsSetCard(0x5) or c:IsCode(6150044,64454614,82710016,99189322)
end
local dtc=Duel.TossCoin
global_arcana_fortune=false
function Duel.TossCoin(p,ev)
	local c1,c2,c3,c4,c5=dtc(p,ev)
	if global_arcana_fortune then
		global_arcana_fortune=false
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
function Auxiliary.FindFunction(x)
	local f=_G
	for v in x:gmatch("[^%.]+") do
		f=f[v]
	end
	return f
end
local ccopyeff=Card.CopyEffect
function Card.CopyEffect(c,code,...)
	Auxiliary.CopyingCode=code
	local res=ccopyeff(c,code,...)
	Auxiliary.CopyingCode=nil
	return res
end
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

function Card.AddMonsterAttributeComplete(c)
end

EFFECT_GREED_YOUNGER=18453229

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
function Auxiliary.MelancholicOwnerFilter(c,tp)
	return c:GetOwner()==tp
end

GlobalVirusRelease=nil

local dipcd=Duel.IsPlayerCanDraw
function Duel.IsPlayerCanDraw(tp,ct)
	if ct and Duel.IsPlayerAffectedByEffect(tp,EFFECT_GREED_YOUNGER) then
		local g=Duel.GetDecktopGroup(tp,ct)
		return g:FilterCount(Card.IsAbleToHand,nil)==ct
	end
	return dipcd(tp,ct)
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

RACE_ALCHEMIST=0x10000000

GlobalAttributeEvent=false
EVENT_ATTRIBUTE_CHANGE=EVENT_CUSTOM+18452940
FLAG_EFFECT_ATTRIBUTE=18452940

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

local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	cregeff(c,e,forced)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	if c:IsStatus(STATUS_INITIALIZING) and code==40410110 and mt.eff_ct[c][0]==e then
		e:SetCountLimit(9999)
		e:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
			local c=e:GetHandler()
			if chk==0 then
				return c:GetFlagEffect(40410110)<1 or (c:GetFlagEffect(40410110)<2 and Duel.IsPlayerAffectedByEffect(tp,18452953))
			end
			c:RegisterFlagEffect(40410110,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
		end)
	end
end

EFFECT_LINK_FACEDOWN_SUB=18453034
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
--	Auxiliary.LExtraMaterialCount(tg,lc,tp)
	Duel.SendtoGrave(tg,REASON_MATERIAL+REASON_LINK)
end

if IREDO_COMES_TRUE or (YGOPRO_VERSION~="Core") then
	Auxiliary.RegisterSilentMajority()
end

local cregeff=Card.RegisterEffect
EVENT_OLDGOD_FORCED=18453128
FLAG_EFFECT_OLDGOD=18453128
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	if code==5257687 and mt.eff_ct[c][0]==e then
		Auxiliary.MetatableEffectCount=false
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_OLDGOD_FORCED)
		e:SetCost(Auxiliary.OldGodCost1)
		e1:SetCost(Auxiliary.OldGodCost2)
		e1:SetTarget(e:GetTarget())
		e1:SetOperation(e:GetOperation())
		cregeff(c,e1)
		Auxiliary.MetatableEffectCount=true
		mt.oldgod_mzone=true
	end
	if code==70307656 and mt.eff_ct[c][2]==e then
		Auxiliary.MetatableEffectCount=false
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_OLDGOD_FORCED)
		e1:SetOperation(e:GetOperation())
		cregeff(c,e1)
		Auxiliary.MetatableEffectCount=true
		mt.oldgod_mzone=true
	end
	if code==78636495 and mt.eff_ct[c][0]==e then
		Auxiliary.MetatableEffectCount=false
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_OLDGOD_FORCED)
		e:SetCost(Auxiliary.OldGodCost1)
		e1:SetCost(Auxiliary.OldGodCost2)
		e1:SetOperation(e:GetOperation())
		cregeff(c,e1)
		Auxiliary.MetatableEffectCount=true
		mt.oldgod_mzone=true
	end
	if code==39180960 and mt.eff_ct[c][0]==e then
		Auxiliary.MetatableEffectCount=false
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_OLDGOD_FORCED)
		e:SetCost(Auxiliary.OldGodCost1)
		e1:SetCost(Auxiliary.OldGodCost2)
		e1:SetTarget(e:GetTarget())
		e1:SetOperation(e:GetOperation())
		cregeff(c,e1)
		Auxiliary.MetatableEffectCount=true
		mt.oldgod_mzone=true
	end
	if code==75285069 and mt.eff_ct[c][1]==e then
		Auxiliary.MetatableEffectCount=false
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_OLDGOD_FORCED)
		e:SetCost(Auxiliary.OldGodCost1)
		e1:SetCost(Auxiliary.OldGodCost2)
		e1:SetTarget(e:GetTarget())
		e1:SetOperation(e:GetOperation())
		cregeff(c,e1)
		Auxiliary.MetatableEffectCount=true
		mt.oldgod_mzone=true
	end
	if code==7914843 and mt.eff_ct[c][0]==e then
		Auxiliary.MetatableEffectCount=false
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_OLDGOD_FORCED)
		e:SetCost(Auxiliary.OldGodCost1)
		e1:SetCost(Auxiliary.OldGodCost2)
		e1:SetTarget(e:GetTarget())
		e1:SetOperation(e:GetOperation())
		cregeff(c,e1)
		Auxiliary.MetatableEffectCount=true
		mt.oldgod_mzone=true
	end
	if code==44913552 and mt.eff_ct[c][0]==e then
		Auxiliary.MetatableEffectCount=false
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_OLDGOD_FORCED)
		e1:SetOperation(e:GetOperation())
		cregeff(c,e1)
		Auxiliary.MetatableEffectCount=true
		mt.oldgod_mzone=true
	end
	if code==18453130 and mt.eff_ct[c][0]==e then
		Auxiliary.MetatableEffectCount=false
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_OLDGOD_FORCED)
		e1:SetOperation(e:GetOperation())
		cregeff(c,e1)
		Auxiliary.MetatableEffectCount=true
		mt.oldgod_mzone=true
	end
	cregeff(c,e,forced,...)
end

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

Auxiliary.oldgod_codes={5257687,70307656,78636495,39180960,75285069,4035199,31242786,2792265,7914843,44913552,18453130}

FLAG_EFFECT_GEMINI=18453156
EFFECT_GEMINI_STAR=18453157

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
		e2:SetTarget(Auxiliary.TargetBoolFunction(Card.IsSetCard,"Á¦¹Ì´Ï:"))
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

local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	if (code==41587307 or code==42199039) and mt.eff_ct[c][0]==e then
		cregeff(c,e,forced,...)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(0)
		cregeff(c,e1)
		mt.eff_ct[c][1]=e1
	elseif code==99970320 and mt.eff_ct[c][0]==e then
		cregeff(c,e,forced,...)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(0)
		cregeff(c,e1)
		mt.eff_ct[c][1]=e1
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		cregeff(c,e2)
		mt.eff_ct[c][2]=e2
	else
		cregeff(c,e,forced,...)
	end
end

EFFECT_EXTRA_RITUAL_MATERIAL_CHARLOTTE=18453188
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

local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)
	if code==38199696 and mt.eff_ct[c][0]==e then
		e:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			if not p or not d then
				Duel.Recover(tp,500,REASON_EFFECT)
				return
			end
			Duel.Recover(p,d,REASON_EFFECT)
		end)
	elseif code==20871001 and mt.eff_ct[c][0]==e then
		e:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			if not p or not d then
				Duel.Recover(tp,400,REASON_EFFECT)
				return
			end
			Duel.Recover(p,d,REASON_EFFECT)
		end)
	end
end

RESETS_STANDARD_DISABLE=RESETS_STANDARD+RESET_DISABLE

local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)
	if code==23434538 and mt.eff_ct[c][0]==e then
		function mt.filter(c,sp)
			return c:GetSummonPlayer()==sp and c:GetLocation()~=0
		end
	elseif code==99000133 and mt.eff_ct[c][0]==e then
		function mt.cfilter(c,tp)
			return c:GetSummonPlayer()==tp and c:GetLocation()~=0
		end
	end
end

if not Duel.HintActivation then
	function Duel.HintActivation(te)
		Duel.Hint(HINT_CARD,0,te:GetHandler():GetCode())
	end
end

CARD_EINE_KLEINE=18452775
EFFECT_EINE_KLEINE=18452775

EFFECT_GREED_SWALLOW=18453231
EFFECT_GREED_OLDER=18453233

local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)
	if code==18452777 and mt.eff_ct[c][0]==e then
		e:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
			local g1=Duel.GMGroup(mt.cfil1,tp,"E",0,nil)
			local g2=Group.CreateGroup()
			if Duel.IsPlayerAffectedByEffect(tp,EFFECT_GREED_SWALLOW) then
				local sg=Duel.GetFieldGroup(tp,LSTN("D"),0)
				if #sg<10 then
					return false
				end
				local ct=sg:GetClassCount(Card.GetCode)
				for i=1,10 do
					local seq=-1
					local tc=sg:GetFirst()
					local rcard=nil
					while tc do
						if tc:GetSequence()>seq
							and (i>ct or not g2:IsExists(Card.IsCode,1,nil,tc:GetCode())) then
							seq=tc:GetSequence()
							rcard=tc
						end
						tc=sg:GetNext()
					end
					g2:AddCard(rcard)
				end
			else
				g2=Duel.GetDecktopGroup(tp,10)
			end
			if chk==0 then
				return #g1>5 and g2:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==10
					and Duel.GetFieldGroupCount(tp,LSTN("D"),0)>13
			end
			Duel.DisableShuffleCheck()
			local rg=Group.CreateGroup()
			if Duel.IsPlayerAffectedByEffect(tp,EFFECT_GREED_SWALLOW) then
				local ct=g1:GetClassCount(Card.GetCode)
				for i=1,6 do
					if i>ct then
						local tg=g1:Clone()
						tg:Sub(rg)
						local sg=tg:RandomSelect(tp,1)
						rg:Merge(sg)
					else
						local tg=g1:Clone()
						local tc=rg:GetFirst()
						while tc do
							local cg=tg:Filter(Card.IsCode,nil,tc:GetCode())
							tg:Sub(cg)
							tc=rg:GetNext()
						end
						local sg=tg:RandomSelect(tp,1)
						rg:Merge(sg)
					end
				end
			else
				rg=g1:RandomSelect(tp,6)
			end
			rg:Merge(g2)
			Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
		end)
		e:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			Duel.Draw(tp,4,REASON_EFFECT)
			if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_GREED_OLDER) then
				local e1=MakeEff(c,"F")
				e1:SetCode(EFFECT_CANNOT_DRAW)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetTR(1,0)
				Duel.RegisterEffect(e1,tp)
			end
		end)
	elseif code==35261759 and mt.eff_ct[c][0]==e then
		e:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
			local g=Group.CreateGroup()
			if Duel.IsPlayerAffectedByEffect(tp,EFFECT_GREED_SWALLOW) then
				local sg=Duel.GetFieldGroup(tp,LSTN("D"),0)
				if #sg<10 then
					return false
				end
				local ct=sg:GetClassCount(Card.GetCode)
				for i=1,10 do
					local seq=-1
					local tc=sg:GetFirst()
					local rcard=nil
					while tc do
						if tc:GetSequence()>seq
							and (i>ct or not g:IsExists(Card.IsCode,1,nil,tc:GetCode())) then
							seq=tc:GetSequence()
							rcard=tc
						end
						tc=sg:GetNext()
					end
					g:AddCard(rcard)
				end
			else
				g=Duel.GetDecktopGroup(tp,10)
			end
			if chk==0 then
				return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==10
					and Duel.GetFieldGroupCount(tp,LSTN("D"),0)>11
			end
			Duel.DisableShuffleCheck()
			Duel.Remove(g,POS_FACEDOWN,REASON_COST)
		end)
	elseif code==84211599 and mt.eff_ct[c][0]==e
		and IREDO_COMES_TRUE then
		e:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
			local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_EXTRA,0,nil,POS_FACEDOWN)
			local count=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
			local b1=#g>=3 and count>=3 and Duel.GetDecktopGroup(tp,3):IsExists(Card.IsAbleToHand,1,nil)
			local b2=#g>=6 and count>=6 and Duel.GetDecktopGroup(tp,6):IsExists(Card.IsAbleToHand,1,nil)
			if chk==0 then
				if e:GetLabel()~=100 then return false end
				e:SetLabel(0)
				return (Duel.GetFlagEffect(tp,84211599)==0 or Duel.IsPlayerAffectedByEffect(tp,EFFECT_GREED_SWALLOW))
					and (b1 or b2)
			end
			local op=0
			if b1 and b2 then
				op=Duel.SelectOption(tp,aux.Stringid(84211599,0),aux.Stringid(84211599,1))
			else
				op=Duel.SelectOption(tp,aux.Stringid(84211599,0))
			end
			local ct= op==0 and 3 or 6
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=g:Select(tp,ct,ct,nil)
			Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
			Duel.SetTargetPlayer(tp)
			Duel.SetTargetParam(ct)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
			if not e:IsHasType(EFFECT_TYPE_ACTIVATE) or Duel.IsPlayerAffectedByEffect(tp,EFFECT_GREED_SWALLOW) then return end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_DRAW)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end)
		e:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.ConfirmDecktop(p,d)
			local g=Duel.GetDecktopGroup(p,d)
			if #g>0 then
				Duel.DisableShuffleCheck()
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
				local sc=g:Select(p,1,1,nil):GetFirst()
				if sc:IsAbleToHand() then
					Duel.SendtoHand(sc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-p,sc)
					Duel.ShuffleHand(p)
				else
					Duel.SendtoGrave(sc,REASON_RULE)
				end
			end
			if #g>1 then
				Duel.SortDecktop(tp,tp,#g-1)
				for i=1,#g-1 do
					local dg=Duel.GetDecktopGroup(tp,1)
					Duel.MoveSequence(dg:GetFirst(),1)
				end
			end
			if not e:IsHasType(EFFECT_TYPE_ACTIVATE) or Duel.IsPlayerAffectedByEffect(tp,EFFECT_GREED_SWALLOW) then return end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetValue(mt.damval)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end)
	end
end

local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)
	if code==67750322 and mt.eff_ct[c][0]==e then
		local con=e:GetCondition()
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local rc=re:GetHandler()
			if rc.delightsworn then
				return true
			end
			return con(e,tp,eg,ep,ev,re,r,rp)
		end)
	elseif code==59438930 and mt.eff_ct[c][0]==e then
		local con=e:GetCondition()
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local rc=re:GetHandler()
			if rc.delightsworn then
				return true
			end
			return con(e,tp,eg,ep,ev,re,r,rp)
		end)
	elseif code==38814750 and mt.eff_ct[c][1]==e then
		local con=e:GetCondition()
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local rc=re:GetHandler()
			if rc.delightsworn then
				return true
			end
			return con(e,tp,eg,ep,ev,re,r,rp)
		end)
	elseif code==14558127 and mt.eff_ct[c][0]==e then
		local con=e:GetCondition()
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local rc=re:GetHandler()
			if rc.delightsworn then
				return true
			end
			return con(e,tp,eg,ep,ev,re,r,rp)
		end)
	elseif code==73642296 and mt.eff_ct[c][0]==e then
		local con=e:GetCondition()
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local rc=re:GetHandler()
			if rc.delightsworn then
				return true
			end
			return con(e,tp,eg,ep,ev,re,r,rp)
		end)
	elseif code==52038441 and mt.eff_ct[c][0]==e then
		local filter1=function(c)
			return c:IsFaceup() and c.delightsworn
		end
		local filter2=function(c,g)
			return (g:IsContains(c) and c:IsLocation(LOCATION_MZONE)) or c.delightsworn
		end
		e:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			local g=eg:Filter(c52038441.cfilter,nil,tp)
			local sg=Duel.GetMatchingGroup(filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			g:Merge(sg)
			if chkc then return chkc:IsOnField() and filter2(chkc,g) end
			if chk==0 then return Duel.IsExistingTarget(filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,g) end
			if g:GetCount()==1 then
				Duel.SetTargetCard(g)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
				Duel.SelectTarget(tp,filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,g)
			end
		end)
		Auxiliary.MetatableEffectCount=false
		local e1=e:Clone()
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local rc=re:GetHandler()
			return rc.delightsworn
		end)
		cregeff(c,e1)
		Auxiliary.MetatableEffectCount=true
	elseif code==99000133 and mt.eff_ct[c][0]==e then
		local con=e:GetCondition()
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local rc=re:GetHandler()
			if rc.delightsworn then
				return true
			end
			return con(e,tp,eg,ep,ev,re,r,rp)
		end)
	elseif code==32415008 and (mt.eff_ct[c][0]==1 or mt.eff_ct[c][0]==2) then
		local con=e:GetCondition()
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local rc=re:GetHandler()
			if rc.delightsworn then
				return true
			end
			return con(e,tp,eg,ep,ev,re,r,rp)
		end)
	elseif code==24508238 and mt.eff_ct[c][0]==e then
		local filter=function(c,tp)
			return c:IsAbleToRemove() and ((c:IsLocation(LOCATION_GRAVE) and c:IsControler(1-tp)) or (c:IsFaceup() and c.delightsworn))
		end
		e:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and filter(chkc,tp) end
			if chk==0 then return Duel.IsExistingTarget(filter,tp,LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil,tp) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectTarget(tp,filter,tp,LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil,tp)
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
		end)
	elseif code==97268402 and mt.eff_ct[c][0]==e then
		local filter=function(c,tp)
			return c:IsFaceup()
				and ((not c:IsDisabled() and c:IsType(TYPE_EFFECT) and c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE))
					or c.delightsworn)
		end
		e:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and filter(chkc,tp) end
			if chk==0 then return Duel.IsExistingTarget(filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectTarget(tp,filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
			Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
		end)
	--temp
	elseif code==10045474 and mt.eff_ct[c][0]==e and YGOPRO_VERSION~="Percy/EDO" then
		local filter=function(c,tp)
			return c:IsFaceup()
				and ((aux.disfilter1(c) and c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE))
					or c.delightsworn)
		end
		e:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and filter(chkc,tp) end
			if chk==0 then return Duel.IsExistingTarget(filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectTarget(tp,filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
		end)
	elseif code==18452762 and mt.eff_ct[c][0]==e then
		local filter=function(c,tp)
			return c:IsFaceup()
				and ((aux.disfilter1(c) and c:IsControler(1-tp) and c:IsType(TYPE_SPELL+TYPE_TRAP))
					or c.delightsworn)
		end
		e:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and filter(chkc,tp) end
			if chk==0 then return Duel.IsExistingTarget(filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectTarget(tp,filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
			Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
		end)
	elseif code==112603120 and mt.eff_ct[c][0]==e then
		local filter=function(c,tp)
			return c:IsFaceup()
				and ((not c:IsDisabled() and c:IsType(TYPE_EFFECT) and not c:IsCode(code)
					and c:IsControler(1-tp)	and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED))
					or c.delightsworn)
		end
		e:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED) and filter(chkc,tp) end
			if chk==0 then
				return Duel.IsExistingTarget(filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil,tp)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectTarget(tp,filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,tp)
			Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
		end)
	elseif code==112603120 and mt.eff_ct[c][1]==e then
		local filter=function(c,tp)
			return c:IsFaceup()
				and ((not c:IsDisabled() and not c:IsType(TYPE_NORMAL) and not c:IsCode(code)
					and c:IsControler(1-tp)	and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED))
					or c.delightsworn)
		end
		e:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED) and filter(chkc,tp) end
			if chk==0 then
				return Duel.IsExistingTarget(filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil,tp)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectTarget(tp,filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,tp)
			Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
		end)
	end
end

function Card.IsNotCode(c,...)
	return not c:IsCode(...)
end

EFFECT_HATOTAURUS_TOKEN=99970687

local dipcssm=Duel.IsPlayerCanSpecialSummonMonster
function Duel.IsPlayerCanSpecialSummonMonster(...)
	local t={...}
	local p=t[1]
	local eset={Duel.IsPlayerAffectedByEffect(p,EFFECT_HATOTAURUS_TOKEN)}
	local code=t[2]
	if #eset>0 and Duel.ReadCard(code,CARDDATA_TYPE)&TYPE_TOKEN>0 then
		t[2]=99970687
		t[3]=0x0
		t[4]=0x4011
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
		t[2]=99970687
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

local cit=Card.IsType
function Card.IsType(c,typ)
	--if typ&TYPE_FIELD==TYPE_FIELD and c:IsType(TYPE_TRAP) then
	--	return cit(c,typ&(~TYPE_FIELD))
	--end
	return cit(c,typ)
end

if not CATEGORY_LVCHANGE then
	CATEGORY_LVCHANGE=0x0
end

pcall(dofile,"expansions/script/yukitokisaki.lua")

local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)
	if e:IsHasType(EFFECT_TYPE_TRIGGER_O) and e:IsHasProperty(EFFECT_FLAG_DELAY) then
		local con=e:GetCondition()
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			if c18453397 then
				table.insert(c18453397[0],e)
			end
			return not con or con(e,tp,eg,ep,ev,re,r,rp)
		end)
	end
end

--dofile("expansions/script/proc_delay.lua")

EFFECT_ALICE_SCARLET=18453385
local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)
	if e:IsHasType(EFFECT_TYPE_ACTIONS) then
		local op=e:GetOperation()
		if op then
			e:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				if Duel.IsPlayerAffectedByEffect(tp,EFFECT_ALICE_SCARLET) then
					return
				end
				if op then
					op(e,tp,eg,ep,ev,re,r,rp)
				end
			end)
		end
	else
		local con=e:GetCondition()
		e:SetCondition(function(e,...)
			local tp=e:GetHandlerPlayer()
			if Duel.IsPlayerAffectedByEffect(tp,EFFECT_ALICE_SCARLET) then
				return false
			end
			return not con or con(e,...)
		end)
	end
end
local dregeff=Duel.RegisterEffect
function Duel.RegisterEffect(e,p,...)
	dregeff(e,p,...)
	if e:IsHasProperty(EFFECT_FLAG_INITIAL) then
		if e:IsHasType(EFFECT_TYPE_ACTIONS) then
			local op=e:GetOperation()
			e:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				if Duel.IsPlayerAffectedByEffect(tp,EFFECT_ALICE_SCARLET) then
					return
				end
				if op then
					op(e,tp,eg,ep,ev,re,r,rp)
				end
			end)
		else
			local con=e:GetCondition()
			e:SetCondition(function(e,...)
				local tp=e:GetHandlerPlayer()
				if Duel.IsPlayerAffectedByEffect(tp,EFFECT_ALICE_SCARLET) then
					return false
				end
				return not con or con(e,...)
			end)
		end
	end
end
local dschlim=Duel.SetChainLimit
function Duel.SetChainLimit(f)
	dschlim(function(e,ep,tp)
		if Duel.IsPlayerAffectedByEffect(tp,EFFECT_ALICE_SCARLET) then
			return true
		end
		return f(e,ep,tp)
	end)
end
local dschlimtce=Duel.SetChainLimitTillChainEnd
function Duel.SetChainLimitTillChainEnd(f)
	dschlimtce(function(e,ep,tp)
		if Duel.IsPlayerAffectedByEffect(tp,EFFECT_ALICE_SCARLET) then
			return true
		end
		return f(e,ep,tp)
	end)
end

local cict=Card.IsCustomType
function Card.IsCustomType(c,ct)
	if ct&CUSTOMTYPE_SQUARE and c:IsCode(18452829,18452830,18452856,18452977) then
		return true
	end
	return cict(c,ct)
end

if not Effect.SetActiveEffect then
	function Effect.SetActiveEffect()
	end
end
CARD_TIME_CAPSULE=11961740
EFFECT_TIME_CAPSULE=11961740
local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)
	if code==CARD_TIME_CAPSULE and mt.eff_ct[c][0]==e then
		e:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			if c:IsRelateToEffect(e) and not c:IsStatus(STATUS_LEAVE_CONFIRMED) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil,tp,POS_FACEDOWN)
				local tc=g:GetFirst()
				if tc and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
					tc:RegisterFlagEffect(CARD_TIME_CAPSULE,RESET_EVENT+RESETS_STANDARD,0,1)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetRange(LOCATION_SZONE)
					e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
					e1:SetCountLimit(1)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
					e1:SetCondition(mt.thcon)
					e1:SetOperation(mt.thop)
					e1:SetLabel(0)
					e1:SetLabelObject(tc)
					c:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_TIME_CAPSULE)
					e2:SetRange(LOCATION_SZONE)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
					e2:SetLabelObject(tc)
					c:RegisterEffect(e2)
				else
					c:CancelToGrave(false)
				end
			end
		end)
	end
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
if not Duel.Exile then
	function Duel.Exile(g,r)
		return Duel.SendtoDeck(g,nil,-2,r)
	end
end


EFFECT_UNPUBLIC=18453549
local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)
	if e:GetCode()==EFFECT_PUBLIC then
		if e:IsHasType(EFFECT_TYPE_SINGLE) then
			local con=e:GetCondition()
			e:SetCondition(function(e)
				local c=e:GetHandler()
				local eset={c:IsHasEffect(EFFECT_UNPUBLIC)}
				for _,te in pairs(eset) do
					local fid=e:GetFieldID()
					local val=te:GetValue()(te,fid)
					if val then
						return false
					end
				end
				return not con or con(e)
			end)
		elseif e:IsHasType(EFFECT_TYPE_FIELD) then
			local tg=e:GetTarget()
			e:SetTarget(function(e,c)
				local eset={c:IsHasEffect(EFFECT_UNPUBLIC)}
				for _,te in pairs(eset) do
					local fid=e:GetFieldID()
					local val=te:GetValue()(te,fid)
					if val then
						return false
					end
				end
				return not tg or tg(e,c)
			end)
		end
	end
end
local dregeff=Duel.RegisterEffect
function Duel.RegisterEffect(e,p,...)
	dregeff(e,p,...)
	if e:GetCode()==EFFECT_PUBLIC then
		if e:IsHasType(EFFECT_TYPE_SINGLE) then
			local con=e:GetCondition()
			e:SetCondition(function(e)
				local c=e:GetHandler()
				local eset={c:IsHasEffect(EFFECT_UNPUBLIC)}
				for _,te in pairs(eset) do
					local fid=e:GetFieldID()
					local val=te:GetValue()(te,fid)
					if val then
						return false
					end
				end
				return not con or con(e)
			end)
		elseif e:IsHasType(EFFECT_TYPE_FIELD) then
			local tg=e:GetTarget()
			e:SetTarget(function(e,c)
				local eset={c:IsHasEffect(EFFECT_UNPUBLIC)}
				for _,te in pairs(eset) do
					local fid=e:GetFieldID()
					local val=te:GetValue()(te,fid)
					if val then
						return false
					end
				end
				return not tg or tg(e,c)
			end)
		end
	end
end

function Auxiliary.RegisterUnpublic(e,c)
	local eset={c:IsHasEffect(EFFECT_PUBLIC)}
	local t={}
	for _,te in pairs(eset) do
		local fid=te:GetFieldID()
		t[fid]=true
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UNPUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabelObject(t)
	e1:SetValue(function(e,fid)
		local t=e:GetLabelObject()
		return t[fid]
	end)
	c:RegisterEffect(e1)
end

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

local cisc=Card.IsSetCard
Auxiliary.ChopinEtudeSetCode=nil
function Card.IsSetCard(c,...)
	local setcode=Auxiliary.ChopinEtudeSetCode
	if setcode then
		return cisc(c,setcode)
	end
	return cisc(c,...)
end

function Duel.SPOI(cc,cat,eg,ev,ep,loc)
	Duel.SetPossibleOperationInfo(cc,cat,eg,ev,ep,LSTN(loc))
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

local dgft=Duel.GetFirstTarget
function Duel.GetFirstTarget(...)
	local ce=dgci(0,CHAININFO_TRIGGERING_EFFECT)
	if Auxiliary.DelayedChainInfo[ce]~=nil then
		local tg=Auxiliary.DelayedChainInfo[ce][CHAININFO_TARGET_CARDS]
		return tg:GetFirst()
	end
	return dgft(...)
end

EFFECT_THE_PHANTOM=18453590

local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)
	if mt.eff_ct and mt.eff_ct[c] then
		local ct=0
		local chk=0
		while true do
			if mt.eff_ct[c][ct]==e then
				chk=true
				break
			end
			if not mt.eff_ct[c][ct] then
				break
			end
			ct=ct+1
		end
		if chk then
			if e:IsHasType(0x7e0) then
				local cl,clm,cc,cf,chi=e:GetCountLimit()
				local e1=e:Clone()
				local con=e1:GetCondition()
				e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					local c=e:GetHandler()
					local eset={c:IsHasEffect(EFFECT_THE_PHANTOM)}
					if e:IsHasType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_TRIGGER_F) then
						if #eset==0 or ep==c:GetControler() or not c:IsLocation(LOCATION_MZONE) then
							return false
						end
					else
						if #eset==0 or tp==c:GetControler() or not c:IsLocation(LOCATION_MZONE) then
							return false
						end
					end
					return not con or con(e,tp,eg,ep,ev,re,r,rp)
				end)
				if cf==(EFFECT_COUNT_CODE_SINGLE>>28) then
					e1:SetCountLimit(999999999)
					local cost=e1:GetCost()
					e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
						local c=e:GetHandler()
						local fid=c:GetFieldID()
						local ct=0
						local eset={c:GetFlagEffectLabel(EFFECT_THE_PHANTOM)}
						for _,te in pairs(eset) do
							if te==fid then
								ct=ct+1
							end
						end
						if chk==0 then
							return (not cost or cost(e,tp,eg,ep,ev,re,r,rp,chk)) and ct<cl
						end
						c:RegisterFlagEffect(EFFECT_THE_PHANTOM,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
						if cost then
							cost(e,tp,eg,ep,ev,re,r,rp,chk)
						end
					end)
				end
				if e:IsHasType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_TRIGGER_F) then
					local prop=e1:GetProperty()
					e1:SetProperty(EFFECT_FLAG_EVENT_PLAYER|prop)
					local ecode=e1:GetCode()
					e1:SetCode(0x10000000|ecode)
					local con=e1:GetCondition()
					e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
						local nep,nrp=rp>>16,rp&0xffff
						return not con or con(e,tp,eg,nep,ev,re,r,nrp)
					end)
					local cost=e1:GetCost()
					e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
						local nep,nrp=rp>>16,rp&0xffff
						return not cost or cost(e,tp,eg,nep,ev,re,r,nrp,chk)
					end)
					local tg=e1:GetTarget()
					e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
						local nep,nrp=rp>>16,rp&0xffff
						return not tg or tg(e,tp,eg,nep,ev,re,r,nrp,chk,chkc)
					end)
					local op=e1:GetOperation()
					e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
						local nep,nrp=rp>>16,rp&0xffff
						return not op or op(e,tp,eg,nep,ev,re,r,nrp)
					end)
					cregeff(c,e1,...)
					local e2=Effect.CreateEffect(c)
					local sf=e:GetType()&(EFFECT_TYPE_SINGLE|EFFECT_TYPE_FIELD)
					e2:SetType(EFFECT_TYPE_CONTINUOUS|sf)
					e2:SetCode(ecode)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
						local c=e:GetHandler()
						if sf&EFFECT_TYPE_SINGLE>0 then
							Duel.RaiseSingleEvent(c,0x10000000|ecode,re,r,rp|(ep<<16),1-c:GetControler(),ev)
						end
						if sf&EFFECT_TYPE_FIELD>0 then
							Duel.RaiseEvent(eg,0x10000000|ecode,re,r,rp|(ep<<16),1-c:GetControler(),ev)
						end
					end)
					cregeff(c,e2,...)
				else
					local prop=e1:GetProperty()
					e1:SetProperty(EFFECT_FLAG_BOTH_SIDE|prop)
					cregeff(c,e1,...)
				end
			end
		end
	end
end

--dofile("expansions/script/proto.lua")

--dofile("expansions/script/RDD.lua")

--dofile("expansions/script/fairduel.lua")
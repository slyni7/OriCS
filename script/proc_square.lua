REASON_SQUARE=0x800000
CUSTOMTYPE_SQUARE=0x1
SUMMON_TYPE_SQUARE=0x40009000
EFFECT_EXTRA_SQUARE_MANA=18452834
EFFECT_SQUARE_MANA_DECLINE=18452974
EFFECT_EXTRA_SQUARE_MATERIAL=18452975
EFFECT_SET_SQUARE_MANA=18453154
EFFECT_CANNOT_BE_SQUARE_MATERIAL=18451017

function Card.IsCanBeSquareMaterial(c,sqr)
	if c:IsForbidden() then
		return false 
	end
	local eset={c:IsHasEffect(EFFECT_CANNOT_BE_SQUARE_MATERIAL)}
	for _,te in pairs(eset) do
		local f=te:GetValue()
		if f==1 then return false end
		if f and f(te,sqr) then return false end
	end
	return true
end

function Auxiliary.ProcFitSquare(cm)
	return function(g)
		local st=cm.square_mana
		return Auxiliary.IsFitSquare(g,st)
	end
end

function Card.GetManaCount(c,att)
	local ct=0
	local t=c:GetSquareMana()
	for i=1,#t do
		if t[i]&att==att then
			ct=ct+1
		end
	end
	return ct
end

function Duel.GetManaCount(tp,att)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:GetManaCount(att)
end

function Group.GetManaCount(g,att)
	local ct=0
	local tc=g:GetFirst()
	while tc do
		ct=ct+tc:GetManaCount(att)
		tc=g:GetNext()
	end
	return ct
end

function Card.GetExactManaCount(c,att)
	local ct=0
	local t=c:GetSquareMana()
	for i=1,#t do
		if t[i]==att then
			ct=ct+1
		end
	end
	return ct
end

function Duel.GetExactManaCount(tp,att)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:GetExactManaCount(att)
end

function Group.GetExactManaCount(g,att)
	local ct=0
	local tc=g:GetFirst()
	while tc do
		ct=ct+tc:GetExactManaCount(att)
		tc=g:GetNext()
	end
	return ct
end

function Card.GetExtraSquareMana(c)
	local t={}
	local eset={}
	for _,te in ipairs({c:IsHasEffect(EFFECT_EXTRA_SQUARE_MANA)}) do
		table.insert(eset,te)
	end
	for _,te in ipairs({c:IsHasEffect(EFFECT_SQUARE_MANA_DECLINE)}) do
		table.insert(eset,te)
	end
	for _,te in ipairs({c:IsHasEffect(EFFECT_SET_SQUARE_MANA)}) do
		table.insert(eset,te)
	end
	table.sort(eset,function(e1,e2) return e1:GetFieldID()<e2:GetFieldID() end)
	for _,te in ipairs(eset) do
		if te:GetCode()==EFFECT_EXTRA_SQUARE_MANA then
			local v=te:GetValue()
			if type(v)=='function' then
				local vt={v(te,fc)}
				for i=1,#vt do
					table.insert(t,vt[i])
				end
			end
		elseif te:GetCode()==EFFECT_SQUARE_MANA_DECLINE then
			local v=te:GetValue()
			if type(v)=='function' then
				local vt={v(te,fc)}
				for i=1,#vt do
					for j=1,#t do
						if vt[i]==t[j] then
							table.remove(t,j)
							break
						end
					end
				end
			end
		elseif te:GetCode()==EFFECT_SET_SQUARE_MANA then
			t={}
		end
	end
	return t
end

function Card.GetSquareMana(c)
	local t={}
	local st=c.square_mana
	if st then
		for i=1,#st do
			table.insert(t,st[i])
		end
	end
	local eset={}
	for _,te in ipairs({c:IsHasEffect(EFFECT_EXTRA_SQUARE_MANA)}) do
		table.insert(eset,te)
	end
	for _,te in ipairs({c:IsHasEffect(EFFECT_SQUARE_MANA_DECLINE)}) do
		table.insert(eset,te)
	end
	for _,te in ipairs({c:IsHasEffect(EFFECT_SET_SQUARE_MANA)}) do
		table.insert(eset,te)
	end
	table.sort(eset,function(e1,e2) return e1:GetFieldID()<e2:GetFieldID() end)
	for _,te in ipairs(eset) do
		if te:GetCode()==EFFECT_EXTRA_SQUARE_MANA then
			local v=te:GetValue()
			if type(v)=='function' then
				local vt={v(te,fc)}
				for i=1,#vt do
					table.insert(t,vt[i])
				end
			end
		elseif te:GetCode()==EFFECT_SQUARE_MANA_DECLINE then
			local v=te:GetValue()
			if type(v)=='function' then
				local vt={v(te,fc)}
				for i=1,#vt do
					for j=1,#t do
						if vt[i]==t[j] then
							table.remove(t,j)
							break
						end
					end
				end
			end
		elseif te:GetCode()==EFFECT_SET_SQUARE_MANA then
			local v=te:GetValue()
			if type(v)=='function' then
				local vt={v(te,fc)}
				for i=1,#vt do
					table.insert(t,vt[i])
				end
			end
		end
	end
	return t
end

function Card.IsHasSquareMana(c,att)
	local t=c:GetSquareMana()
	if #t>0 then
		for i=1,#t do
			if t[i]&att==att then
				return true
			end
		end
	end
	return false
end

function Card.IsHasExactSquareMana(c,att)
	local t=c:GetSquareMana()
	if #t>0 then
		for i=1,#t do
			if t[i]==att then
				return true
			end
		end
	end
	return false
end

function Auxiliary.IsFitSquare(mg,st,fc)
	local mt={}
	local chain=Duel.GetCurrentChain()
	local p=chain==0 and Duel.GetTurnPlayer() or Duel.GetChainInfo(0,CHAININFO_TRIGGERING_PLAYER)
	local eset={Duel.IsPlayerAffectedByEffect(p,EFFECT_EXTRA_SQUARE_MANA)}
	for _,te in pairs(eset) do
		local v=te:GetValue()
		if type(v)=='function' then
			local vt={v(te,fc)}
			for i=1,#vt do
				table.insert(mt,vt[i])
			end
		end
	end
	return Auxiliary.SquareCheck(mg,st,mt,false)
end

function Auxiliary.SquareCheck(g,sqt,exsqt,ovchk)
	local bchk=0x0
	local res=false
	if not g then
		local msqt={}
		for i=1,#exsqt do
			table.insert(msqt,exsqt[i])
		end
		local sqbt={}
		local msqbt={}
		for i=0,127 do
			sqbt[i]=0
			msqbt[i]=0
		end
		for i=1,#sqt do
			sqbt[sqt[i]]=sqbt[sqt[i]]+1
		end
		for i=1,#msqt do
			for j=0,msqt[i] do
				if j&msqt[i]==j then
					msqbt[j]=msqbt[j]+1
				end
			end
		end
		res=true
		for i=0,127 do
			if msqbt[i]<sqbt[i] then
				res=false
				break
			end
		end
		return res
	end
	while bchk<(1<<#g) do
		local msqt={}
		for i=1,#exsqt do
			table.insert(msqt,exsqt[i])
		end
		local tc=g:GetFirst()
		local index=0
		while tc do
			if bchk&(1<<index)~=0x0 then
				local tsqt=tc:GetSquareMana()
				for i=1,#tsqt do
					table.insert(msqt,tsqt[i])
				end
			else
				local lv=tc:IsType(TYPE_XYZ) and tc:GetRank() or tc:GetLevel()
				for i=1,lv do
					table.insert(msqt,tc:GetAttribute())
				end
				local esqt=tc:GetExtraSquareMana()
				for i=1,#esqt do
					table.insert(msqt,esqt[i])
				end
			end
			index=index+1
			tc=g:GetNext()
		end
		local sqbt={}
		local msqbt={}
		for i=0,127 do
			sqbt[i]=0
			msqbt[i]=0
		end
		for i=1,#sqt do
			sqbt[sqt[i]]=sqbt[sqt[i]]+1
		end
		for i=1,#msqt do
			for j=0,msqt[i] do
				if j&msqt[i]==j then
					msqbt[j]=msqbt[j]+1
				end
			end
		end
		res=true
		for i=0,127 do
			if msqbt[i]<sqbt[i] then
				res=false
				break
			end
		end
		if res then
			break
		end
		bchk=bchk+1
	end
	if res and ovchk then
		local sg=nil
		local tc=g:GetFirst()
		while tc do
			sg=g:Clone()
			sg:RemoveCard(tc)
			res=not Auxiliary.SquareCheck(sg,sqt,exsqt,false)
			if not res then
				break
			end
			tc=g:GetNext()
		end
	end
	return res
end

function Auxiliary.AddSquareProcedure(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetDescription(aux.Stringid(18452813,0))
	e1:SetValue(SUMMON_TYPE_SQUARE)
	e1:SetCondition(Auxiliary.SquareCondition)
	e1:SetTarget(Auxiliary.SquareTarget)
	e1:SetOperation(Auxiliary.SquareOperation)
	c:RegisterEffect(e1)
end
function Auxiliary.SquareMaterialFilter(c,sqr)
	return c:IsFaceup() and c:IsCanBeSquareMaterial(sqr)
end
function Auxiliary.ExtraSquareMaterialFilter(c)
	return c:IsHasEffect(EFFECT_EXTRA_SQUARE_MATERIAL) and c:IsAbleToRemove()
end
function Duel.GetSquareMaterial(tp,c)
	local g=Duel.GetMatchingGroup(Auxiliary.SquareMaterialFilter,tp,LOCATION_MZONE,0,nil,c)
	local exg=Duel.GetMatchingGroup(Auxiliary.ExtraSquareMaterialFilter,tp,LOCATION_GRAVE,0,nil)
	g:Merge(exg)
	return g
end
function Auxiliary.SquareCondition(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local g=Duel.GetSquareMaterial(tp,c)
	local st=c.square_mana
	local mt={}
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_SQUARE_MANA)}
	for _,te in pairs(eset) do
		local v=te:GetValue()
		if type(v)=='function' then
			local vt={v(te,c)}
			for i=1,#vt do
				table.insert(mt,vt[i])
			end
		end
	end
	local res=Auxiliary.SquareCheck(g,st,mt,false)
	return res
end
function Auxiliary.SquareTarget(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetSquareMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(18452813,1))
	local cancel=Duel.GetCurrentChain()==0
	local st=c.square_mana
	local mt={}
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_SQUARE_MANA)}
	for _,te in pairs(eset) do
		local v=te:GetValue()
		if type(v)=='function' then
			local vt={v(te,c)}
			for i=1,#vt do
				table.insert(mt,vt[i])
			end
		end
	end
	local sg=g:SelectSubGroup(tp,Auxiliary.SquareCheck,cancel,0,#g,st,mt,true)
	if Auxiliary.SquareCheck(sg,st,mt,true) then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else
		return false
	end
end
function Auxiliary.SquareOperation(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	local exg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	g:Sub(exg)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SQUARE)
	Duel.Remove(exg,POS_FACEUP,REASON_MATERIAL+REASON_SQUARE)
	local tc=g:GetFirst()
	while tc do
		Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,e,REASON_SQUARE,tp,tp,0)
		tc=g:GetNext()
	end
	Duel.RaiseEvent(g,EVENT_BE_MATERIAL,e,REASON_SQUARE,tp,tp,0)
	g:DeleteGroup()
end

function Auxiliary.RegisterSquareString()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetOperation(Auxiliary.SquareStringOperation)
	Duel.RegisterEffect(e1,0)
end

EFFECT_SQUARE_STRING=127800000

function Auxiliary.SquareStringOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0xff,0xff,nil)
	local tc=g:GetFirst()
	while tc do
		local tcsmt=tc:GetSquareMana()
		local chkt={}
		for i=1,#tcsmt do
			local att=tcsmt[i]&0x7f
			if chkt[att]==nil then
				chkt[att]=0
			end
			chkt[att]=chkt[att]+1
		end
		for i=0,127 do
			local eset={tc:IsHasEffect(EFFECT_SQUARE_STRING+i)}
			for _,te in pairs(eset) do
				te:Reset()
			end
			if chkt[i]~=nil then
				local sid=math.min(15,chkt[i]-1)
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SQUARE_STRING+i)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetDescription(aux.Stringid(EFFECT_SQUARE_STRING+i,sid))
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
		tc=g:GetNext()
	end
end

Auxiliary.RegisterSquareString()
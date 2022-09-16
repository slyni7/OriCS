SUMMON_TYPE_ACCESS=0x40003000
TYPE_ACCESS=0x8000000
REASON_ACCESS=0x20000000
CYAN_EFFECT_CANNOT_BE_ACCESS_MATERIAL=500
CYAN_EFFECT_ACCESS_LEVEL=501
CYAN_EFFECT_ACCESS_ATTACK=502
CYAN_EFFECT_CANNOT_BE_ADMIN=503
EFFECT_HIIJACK_ACCESS=504

local ov=Duel.Overlay
function Duel.Overlay(xc,mt)
	if aux.GetValueType(mt)=="Group" then
			local tc=mt:GetFirst()
			while tc do
				if tc:IsType(TYPE_ACCESS) then
					local ad=tc:GetAdmin()
					if ad then Duel.SendtoGrave(ad,REASON_RULE) end
				end
				tc=mt:GetNext()
			end
		else
			if mt:IsType(TYPE_ACCESS) then
				local ad=mt:GetAdmin()
				if ad then
					Duel.SendtoGrave(ad,REASON_RULE)
				end
			end
		end
	return ov(xc,mt)
end
-- function Duel.Overlay(xc,mt)
	-- if xc:IsType(TYPE_ACCESS) then
		-- if xc:GetAdmin() then
			-- Duel.SendtoGrave(mt,REASON_RULE)
		-- else
			-- if aux.GetValueType(mt)=="Group" then
				-- if mt:GetCount()>1 then
					-- local ad=mt:GetFirst()
					-- mt:Sub(ad)
					-- Duel.SendtoGrave(mt,REASON_RULE)
					-- mt=ad
				-- end
			-- end
		-- end
	-- else
		-- if aux.GetValueType(mt)=="Group" then
			-- local tc=mt:GetFirst()
			-- while tc do
				-- if tc:IsType(TYPE_ACCESS) then
					-- local ad=tc:GetAdmin()
					-- if ad then Duel.SendtoGrave(ad,REASON_RULE) end
				-- end
				-- tc=mt:GetNext()
			-- end
		-- else
			-- if mt:IsType(TYPE_ACCESS) then
				-- local ad=mt:GetAdmin()
				-- Duel.SendtoGrave(ad,REASON_RULE)
			-- end
		-- end
	-- end
	-- return ov(xc,mt)
-- end
function Duel.AdminOverlay(xc,mt)
	if aux.GetValueType(mt)=="Group" then
		local tc=mt:GetFirst()
		while tc do
			if tc:IsType(TYPE_ACCESS) then
				local ad=tc:GetAdmin()
				ov(xc,ad)
			end
			tc=mt:GetNext()
		end
	else
		if mt:IsType(TYPE_ACCESS) then
			local ad=mt:GetAdmin()
			Duel.SendtoGrave(ad,REASON_RULE)
			ov(xc,ad)
		end
	end
	return ov(xc,mt)	
end
function cyan.IsCanBeAccessMaterial(c,acc)
	if c:IsForbidden() then
		return false 
	end
	local le={c:IsHasEffect(CYAN_EFFECT_CANNOT_BE_ACCESS_MATERIAL)}
	for _,te in pairs(le) do
		local f=te:GetValue()
		if f and f(te,acc) then return false end
	end
	return true
end
function cyan.GetAccessLevel(c,acc)
	local le={c:IsHasEffect(CYAN_EFFECT_ACCESS_LEVEL)}
	for _,te in pairs(le) do
		local f=te:GetValue()
		if f then return f(te,acc) end 
	end
	return c:GetLevel()
end
function cyan.IsCanBeAdmin(c,acc)
	if c:IsType(TYPE_TOKEN) then return false end
	local le={c:IsHasEffect(CYAN_EFFECT_CANNOT_BE_ADMIN)}
	for _,te in pairs(le) do
		local f=te:GetValue()
		if f==1 then return false end
		if f and f(te,acc) then return false end
	end
	return true
end
function cyan.GetAccessAttack(c,acc)
	local le={c:IsHasEffect(CYAN_EFFECT_ACCESS_ATTACK)}
	for _,te in pairs(le) do
		local f=te:GetValue()
		if f then return f(te,c,acc) end 
	end
	return c:GetAttack()
end
function Duel.AccessSummon(tp,mt,ac)

end
function cyan.nacon(e)
	local ad=e:GetHandler():GetAdmin()
	return ad==nil
end

--액세스 소환
function cyan.AddAccessProcedure(c,f1,f2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_ACCESS)
	e1:SetCondition(cyan.AccessCondition(f1,f2))
	e1:SetOperation(cyan.AccessOperation(f1,f2))
	c:RegisterEffect(e1)
end
function cyan.AccessExCheck(c,g,ac)
	local exchk=Group.CreateGroup()
	exchk:AddCard(c)
	exchk:AddCard(g)
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,exchk,ac)>0
end
function cyan.NoLevelFilter(c)
	return not (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
end
function cyan.AccessFilter1(c,ac,f1,f2,tp)
	if f1(c) and c:IsFaceup() and cyan.IsCanBeAccessMaterial(c,ac) then
		local mg=Group.CreateGroup()
		if cyan.GetAccessAttack(c,ac)>ac:GetAttack()
			or c:GetAttack()>ac:GetAttack() then
			local g1=Duel.GetMatchingGroup(cyan.AccessFilter2,tp,LOCATION_MZONE,0,c,ac,f2)
			g1=g1:Filter(cyan.AccessExCheck,nil,c,ac)
			mg:Merge(g1)
		end
		if cyan.GetAccessAttack(c,ac)<ac:GetAttack()
			or c:GetAttack()<ac:GetAttack()	then
			local g2=Duel.GetMatchingGroup(cyan.AccessFilter3,tp,LOCATION_MZONE,0,c,ac,f2)
			g2=g2:Filter(cyan.AccessExCheck,nil,c,ac)
			mg:Merge(g2)
		end
		if not c:IsType(TYPE_LINK+TYPE_XYZ) then
			if cyan.GetAccessLevel(c,ac)>ac:GetLevel() 
				or c:GetLevel()>ac:GetLevel() then
				local g3=Duel.GetMatchingGroup(cyan.AccessFilter4,tp,LOCATION_MZONE,0,c,ac,f2)
				g3=g3:Filter(cyan.AccessExCheck,nil,c,ac)					
			mg:Merge(g3)
			end
			if cyan.GetAccessLevel(c,ac)<ac:GetLevel() 
				or c:GetLevel()<ac:GetLevel()then
				local g4=Duel.GetMatchingGroup(cyan.AccessFilter5,tp,LOCATION_MZONE,0,c,ac,f2)
				g4=g4:Filter(cyan.AccessExCheck,nil,c,ac)
				mg:Merge(g4)
			end
		end
		if not cyan.IsCanBeAdmin(c,ac) then
			mg=mg:Filter(cyan.AccessFilter6,nil)
		end
		mg=mg:Filter(cyan.AccessExCheck,nil,c,ac)
		mg=mg:Filter(cyan.IsCanBeAccessMaterial,nil,ac)
		return mg:GetCount()>0
	end
	return false
end
function cyan.AccessFilter2(c,ac,f)
	return f(c) and c:IsFaceup() 
		and (cyan.GetAccessAttack(c,ac)<ac:GetAttack() or c:GetAttack()<ac:GetAttack())
end
function cyan.AccessFilter3(c,ac,f)
	return f(c) and c:IsFaceup() 
		and (cyan.GetAccessAttack(c,ac)>ac:GetAttack() or c:GetAttack()>ac:GetAttack())
end
function cyan.AccessFilter4(c,ac,f)
	return f(c) and c:IsFaceup() 
		and (cyan.GetAccessLevel(c,ac)<ac:GetLevel() or c:GetLevel()<ac:GetLevel())
		and not c:IsType(TYPE_LINK+TYPE_XYZ)
end
function cyan.AccessFilter5(c,ac,f)
	return f(c) and c:IsFaceup() 
		and (cyan.GetAccessLevel(c,ac)>ac:GetLevel() or c:GetLevel()>ac:GetLevel())
		and not c:IsType(TYPE_LINK+TYPE_XYZ)	
end
function cyan.AccessFilter6(c,ac,f)
	return cyan.IsCanBeAdmin(c,ac)
end
function cyan.AccessCondition(f1,f2)
	return
		function(e,c)
			if c==nil then
				return true
			end
			local tp=c:GetControler()
			if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_ACCESS,tp,false,false) then return false end
			return Duel.IsExistingMatchingCard(cyan.AccessFilter1,tp,LOCATION_MZONE,0,1,nil,c,f1,f2,tp)
		end
end
function cyan.AccMaterialEvent(g,e,tp)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_ACCESS)
	local tc=g:GetFirst()
	while tc do
		Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,e,REASON_ACCESS,tp,tp,0)
		tc=g:GetNext()
	end
	Duel.RaiseEvent(g,EVENT_BE_MATERIAL,e,REASON_ACCESS,tp,tp,0)
end
function cyan.HiiJackCheck(c,acc,hj)
	local le={c:IsHasEffect(EFFECT_HIIJACK_ACCESS)}
	for _,te in pairs(le) do
		local f=te:GetValue()
		if f and f(te,acc,hj) then return true end
	end
	return false
end
function cyan.AccessOperation(f1,f2)
	local HiiJackLocationCount=false
	return
		function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
			local g=Duel.SelectMatchingCard(tp,cyan.AccessFilter1,tp,LOCATION_MZONE,0,0,1,nil,c,f1,f2,tp)
			if g:GetCount()==0 then return end
			local tc=g:GetFirst()
			local mg=Group.CreateGroup()
			
			if cyan.GetAccessAttack(tc,ac)>c:GetAttack()
				or tc:GetAttack()>c:GetAttack() then
				local g1=Duel.GetMatchingGroup(cyan.AccessFilter2,tp,LOCATION_MZONE,0,tc,c,f2)
				mg:Merge(g1)
				if f2(tc) then
					local g5=Duel.GetMatchingGroup(cyan.AccessFilter2,tp,LOCATION_MZONE,0,tc,c,f1)
					mg:Merge(g5)
				end
			end
			if cyan.GetAccessAttack(tc,ac)<c:GetAttack() 
				or tc:GetAttack()<c:GetAttack()then
				local g2=Duel.GetMatchingGroup(cyan.AccessFilter3,tp,LOCATION_MZONE,0,tc,c,f2)
				mg:Merge(g2)
				if f2(tc) then
					local g6=Duel.GetMatchingGroup(cyan.AccessFilter3,tp,LOCATION_MZONE,0,tc,c,f1)
					mg:Merge(g6)
				end
			end
			if not c:IsType(TYPE_LINK+TYPE_XYZ) then
				if cyan.GetAccessLevel(tc,ac)>c:GetLevel() 
					or tc:GetLevel()>c:GetLevel() then
					local g3=Duel.GetMatchingGroup(cyan.AccessFilter4,tp,LOCATION_MZONE,0,tc,c,f2)
					mg:Merge(g3)
					if f2(tc) then
						local g7=Duel.GetMatchingGroup(cyan.AccessFilter4,tp,LOCATION_MZONE,0,tc,c,f1)
						mg:Merge(g7)
					end
				end
				if cyan.GetAccessLevel(tc,ac)<c:GetLevel()
					or tc:GetLevel()<c:GetLevel() then
					local g4=Duel.GetMatchingGroup(cyan.AccessFilter5,tp,LOCATION_MZONE,0,tc,c,f2)
					mg:Merge(g4)
					if f2(tc) then
						local g8=Duel.GetMatchingGroup(cyan.AccessFilter5,tp,LOCATION_MZONE,0,tc,c,f1)
						mg:Merge(g8)
					end
				end
			end
			if not cyan.IsCanBeAdmin(tc,ac) then
				mg=mg:Filter(cyan.AccessFilter6,nil)
			end
			mg=mg:Filter(cyan.AccessExCheck,nil,tc,c)
			mg=mg:Filter(cyan.IsCanBeAccessMaterial,nil,ac)
			local ag=mg:Select(tp,0,1,nil)
			if ag:GetCount()==0 then return end
			g:Merge(ag)
			g:KeepAlive()
			c:SetMaterial(g)
			if Duel.GetLocationCountFromEx(tp,tp,g,c)>1 then
				HiiJackLocationCount=true
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sg1=g:Filter(cyan.AccessFilter6,nil)
			local xg=sg1:Select(tp,1,1,nil)
			local xc=xg:GetFirst()
			g:RemoveCard(xc)
			local mg2=xg:GetFirst():GetOverlayGroup()
			if xg:GetFirst():IsType(TYPE_XYZ) and mg2:GetCount()~=0 then
				Duel.SendtoGrave(mg2,REASON_RULE)
			end
			local mg3=xg:GetFirst():GetAdmin()
			if xg:GetFirst():IsType(TYPE_ACCESS) and mg3 then
				Duel.SendtoGrave(mg3,REASON_RULE)
			end
			
			Duel.Overlay(c,xg)
			local hj=g:GetFirst()
			if Duel.IsExistingMatchingCard(cyan.HiiJackCheck,tp,LOCATION_EXTRA,0,1,c,c,hj) 
				and HiiJackLocationCount and Duel.SelectYesNo(tp,680) then
				local hacc=Duel.SelectMatchingCard(tp,cyan.HiiJackCheck,tp,LOCATION_EXTRA,0,1,1,nil,c,hj)
				if hacc:GetCount()>0 then
						local ha=hacc:GetFirst()
						Duel.Overlay(ha,hj)
						sg:AddCard(ha)
						ha:CompleteProcedure()
					else
						cyan.AccMaterialEvent(g,e,tp)
						g:DeleteGroup()
					end
			else
				cyan.AccMaterialEvent(g,e,tp)
				g:DeleteGroup()
			end
			sg:AddCard(c)
			c:CompleteProcedure()
			-- Duel.SendtoGrave(g,REASON_MATERIAL+REASON_ACCESS)
			-- local tc=g:GetFirst()
			-- while tc do
				-- Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,e,REASON_ACCESS,tp,tp,0)
				-- tc=g:GetNext()
			-- end
			-- Duel.RaiseEvent(g,EVENT_BE_MATERIAL,e,REASON_ACCESS,tp,tp,0)
			-- g:DeleteGroup()
		end
end
--액세스 이외의 속성 삭제
   local gtype=Card.GetType
   Card.GetType=function(c)
	  if c.AccessMonsterAttribute then
		 return bit.bor(gtype(c),TYPE_FUSION)-TYPE_FUSION
	  end
	  return gtype(c)
   end
   local otype=Card.GetOriginalType
   Card.GetOriginalType=function(c)
	  if c.AccessMonsterAttribute then
		 return bit.bor(otype(c),TYPE_FUSION)-TYPE_FUSION
	  end
	  return otype(c)
   end
   local ftype=Card.GetFusionType
   Card.GetFusionType=function(c)
	  if c.AccessMonsterAttribute then
		 return bit.bor(ftype(c),TYPE_FUSION)-TYPE_FUSION
	  end
	  return ftype(c)
   end
   local ptype=Card.GetPreviousTypeOnField
   Card.GetPreviousTypeOnField=function(c)
	  if c.AccessMonsterAttribute then
		 return bit.bor(ptype(c),TYPE_FUSION)-TYPE_FUSION
	  end
	  return ptype(c)
   end
   local itype=Card.IsType
   Card.IsType=function(c,t)
	  if c.AccessMonsterAttribute then
		 if t==TYPE_FUSION or t==nil then
			return false
		 end
		 return itype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	  end
	  return itype(c,t)
   end
   local iftype=Card.IsFusionType
   Card.IsFusionType=function(c,t)
	  if c.AccessMonsterAttribute then
		 if t==TYPE_FUSION then
			return false
		 end
		 return iftype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	  end
	  return iftype(c,t)
   end
	local covg=Card.GetOverlayGroup
	Card.GetAdmin=function(c)
		if c.AccessMonsterAttribute then
			local cadm=covg(c)
			if cadm then
				local adm=cadm:GetFirst()
				return adm
			end
		end
		return nil
	end
	Card.GetOverlayGroup=function(c)
		if c.AccessMonsterAttribute then
			local g=Group.CreateGroup()
			return g
		end
		return covg(c)
	end
	local covct=Card.GetOverlayCount
	Card.GetOverlayCount=function(c)
		if c.AccessMonsterAttribute then
			return 0
		end
		return covct(c)
	end
	local covchk=Card.CheckRemoveOverlayCard
	Card.CheckRemoveOverlayCard=function(c,tp,ct,r)
		if c.AccessMonsterAttribute then
			return false
		end
		return covchk(c,tp,ct,r)
	end
	Card.CheckRemoveAdmin=function(c,tp,ct,r)
		if c.AccessMonsterAttribute then
			return covchk(c,tp,ct,r)
		end
		return false
	end
	Duel.GetOverlayGroup=function(tp,s,o)
		local g=Group.CreateGroup()
		if s then
			local sg=Duel.GetMatchingGroup(aux.TRUE,tp,s*LOCATION_MZONE,0,nil)
			local sc=sg:GetFirst()
			while sc do
				local smg=sc:GetOverlayGroup()
				g:Merge(smg)
				sc=sg:GetNext()
			end
		end
		if o then
			local og=Duel.GetMatchingGroup(aux.TRUE,tp,0,o*LOCATION_MZONE,nil)
			local oc=og:GetFirst()
			while oc do
				local omg=oc:GetOverlayGroup()
				g:Merge(omg)
				oc=og:GetNext()
			end
		end
		return g
	end
	Duel.GetOverlayCount=function(tp,s,o)
		local ct=0
		if s then
			local sg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
			local sc=sg:GetFirst()
			while sc do
				local sct=sc:GetOverlayCount()
				ct=ct+sct
				sc=sg:GetNext()
			end
		end
		if o then
			local og=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
			local oc=og:GetFirst()
			while oc do
				local oct=oc:GetOverlayCount()
				ct=ct+oct
				oc=og:GetNext()
			end
		end
		return ct
	end
		Duel.GetAdminCount=function(tp,s,o)
		local ct=0
		if s then
			local sg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
			local sc=sg:GetFirst()
			while sc do
				local sct=sc:GetAdmin()
				if sct then 
					ct=ct+1
				end
				sc=sg:GetNext()
			end
		end
		if o then
			local og=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
			local oc=og:GetFirst()
			while oc do
				local oct=oc:GetAdmin()
				if oct then 
					ct=ct+1
				end
				oc=og:GetNext()
			end
		end
		return ct
	end
	Duel.CheckRemoveOverlayCard=function(tp,s,o,ct,r)
		--임시
		return Duel.GetOverlayCount(tp,s,o)>=ct
	end
	Duel.CheckRemoveAdmin=function(tp,s,o,ct,r)
		--임시
		return Duel.GetAdminCount(tp,s,o)>=ct
	end
	Duel.RemoveOverlayCard=function(tp,s,o,mi,ma,r)
		local val=0
		repeat
			local g=Duel.GetMatchingGroup(Card.CheckRemoveOverlayCard,tp,s*LOCATION_MZONE,o*LOCATION_MZONE,nil,tp,1,r)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			tc:RemoveOverlayCard(tp,1,1,r)
			val=val+1
		until val==ma or (val>=mi and Duel.SelectYesNo(tp,12))
		return
	end
	Duel.RemoveAdmin=function(tp,s,o,mi,ma,r)
		local mg=Group.CreateGroup()
		local g=Duel.GetMatchingGroup(Card.GetAdmin,tp,s*LOCATION_MZONE,o*LOCATION_MZONE,nil,tp,1,r)
			tc=g:GetFirst()
			while tc do
				sg=tc:GetAdmin()
				if sg then
					mg:AddCard(sg)
					tc=g:GetNext()
				end
			end
			local rm=mg:Select(tp,mi,ma,nil)
			return Duel.SendtoGrave(rm,r)
	end

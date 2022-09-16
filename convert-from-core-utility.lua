Auxiliary.GetValueType=type

function Auxiliary.AddCodeList(c,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if c.listed_names==nil then
		local mt=getmetatable(c)
		mt.listed_names={}
		for _,code in ipairs({...}) do
			table.insert(c.listed_names,code)
		end
	end
	if c.card_code_list==nil then
		local mt=getmetatable(c)
		mt.card_code_list={}
		for _,code in ipairs({...}) do
			mt.card_code_list[code]=true
		end
	else
		for _,code in ipairs({...}) do
			c.card_code_list[code]=true
		end
	end
end
function Auxiliary.IsCodeListed(c,...)
	local codes={...}
	for _,code in ipairs(codes) do
		if c.listed_names then
			for _,ccode in ipairs(c.listed_names) do
				if code==ccode then
					return true
				end
			end
		end
		if c.card_code_list and c.card_code_list[code] then
			return true
		end
	end
	return false
end
function Auxiliary.IsCounterAdded(c,counter_type)
	if c.counter_list or c.counter_place_list or c.counter_add_list then
		if c.counter_place_list then
			--if it generates, it always manipulates
			for _,ccounter in ipairs(c.counter_place_list) do
				if counter_type==ccounter then return true end
			end
		elseif c.counter_list then
			for _,ccounter in ipairs(c.counter_list) do
				if counter_type==ccounter then return true end
			end
		elseif c.counter_add_list then
			for _,ccounter in ipairs(c.counter_add_list) do
				if counter_type==ccounter then return true end
			end
		end
	else
		return false
	end
end
--return the column of card c (from the viewpoint of p)
function Auxiliary.GetColumn(c,p)
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		if seq==5 then seq=1 elseif seq==6 then seq=3 end
	elseif c:IsLocation(LOCATION_SZONE) then
		if seq>4 then return nil end
	else return nil end
	if c:IsControler(p or 0) then return seq else return 4-seq end
end
--return the column of monster zone seq (from the viewpoint of controller)
function Auxiliary.MZoneSequence(seq)
	if seq==5 then return 1 end
	if seq==6 then return 3 end
	return seq
end
--return the column of spell/trap zone seq (from the viewpoint of controller)
function Auxiliary.SZoneSequence(seq)
	if seq>4 then return nil end
	return seq
end
function Auxiliary.ChangeBattleDamage(player,value)
	return	function(e,damp)
				if player==0 then
					if e:GetOwnerPlayer()==damp then
						return value
					else
						return -1
					end
				elseif player==1 then
					if e:GetOwnerPlayer()==1-damp then
						return value
					else
						return -1
					end
				end
			end
end 
--check for cards with different levels
function Auxiliary.dlvcheck(g)
	return g:GetClassCount(Card.GetLevel)==#g
end
--check for cards with different ranks
function Auxiliary.drkcheck(g)
	return g:GetClassCount(Card.GetRank)==#g
end
--check for cards with different links
function Auxiliary.dlkcheck(g)
	return g:GetClassCount(Card.GetLink)==#g
end
--check for cards with different attributes
function Auxiliary.dabcheck(g)
	return g:GetClassCount(Card.GetAttribute)==#g
end
--check for cards with different races
function Auxiliary.drccheck(g)
	return g:GetClassCount(Card.GetRace)==#g
end
--check for group with 2 cards, each card match f with a1/a2 as argument
function Auxiliary.gfcheck(g,f,a1,a2)
	if #g~=2 then return false end
	local c1=g:GetFirst()
	local c2=g:GetNext()
	return f(c1,a1) and f(c2,a2) or f(c2,a1) and f(c1,a2)
end
--check for group with 2 cards, each card match f1 with a1, f2 with a2 as argument
function Auxiliary.gffcheck(g,f1,a1,f2,a2)
	if #g~=2 then return false end
	local c1=g:GetFirst()
	local c2=g:GetNext()
	return f1(c1,a1) and f2(c2,a2) or f1(c2,a1) and f2(c1,a2)
end
function Auxiliary.mzctcheck(g,tp)
	return Duel.GetMZoneCount(tp,g)>0
end
--used for "except this card"
function Auxiliary.ExceptThisCard(e)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then return c else return nil end
end
--used for multi-linked zone(zone linked by two or more link monsters)
function Auxiliary.GetMultiLinkedZone(tp)
	local f=function(c)
		return c:IsFaceup() and c:IsType(TYPE_LINK)
	end
	local lg=Duel.GetMatchingGroup(f,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local multi_linked_zone=0
	local single_linked_zone=0
	for tc in aux.Next(lg) do
		local zone=tc:GetLinkedZone(tp)&0x7f
		multi_linked_zone=single_linked_zone&zone|multi_linked_zone
		single_linked_zone=single_linked_zone~zone
	end
	return multi_linked_zone
end
Auxiliary.SubGroupCaptured=nil
Auxiliary.GCheckAdditional=nil
function Auxiliary.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	if Auxiliary.GCheckAdditional and not Auxiliary.GCheckAdditional(sg,c,g,f,min,max,ext_params) then
		sg:RemoveCard(c)
		return false
	end
	local res=(#sg>=min and #sg<=max and f(sg,table.unpack(ext_params)))
		or (#sg<max and g:IsExists(Auxiliary.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function Auxiliary.CheckGroupRecursiveCapture(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	if Auxiliary.GCheckAdditional and not Auxiliary.GCheckAdditional(sg,c,g,f,min,max,ext_params) then
		sg:RemoveCard(c)
		return false
	end
	local res=#sg>=min and #sg<=max and f(sg,table.unpack(ext_params))
	if res then
		Auxiliary.SubGroupCaptured:Clear()
		Auxiliary.SubGroupCaptured:Merge(sg)
	else
		res=#sg<max and g:IsExists(Auxiliary.CheckGroupRecursiveCapture,1,sg,sg,g,f,min,max,ext_params)
	end
	sg:RemoveCard(c)
	return res
end
function Group.CheckSubGroup(g,f,min,max,...)
	local min=min or 1
	local max=max or #g
	if min>max then return false end
	local ext_params={...}
	local sg=Duel.GrabSelectedCard()
	if #sg>max or #(g+sg)<min then return false end
	if #sg==max and (not f(sg,...) or Auxiliary.GCheckAdditional and not Auxiliary.GCheckAdditional(sg,nil,g,f,min,max,ext_params)) then return false end
	if #sg>=min and #sg<=max and f(sg,...) and (not Auxiliary.GCheckAdditional or Auxiliary.GCheckAdditional(sg,nil,g,f,min,max,ext_params)) then return true end
	local eg=g:Clone()
	for c in aux.Next(g-sg) do
		if Auxiliary.CheckGroupRecursive(c,sg,eg,f,min,max,ext_params) then return true end
		eg:RemoveCard(c)
	end
	return false
end
function Group.SelectSubGroup(g,tp,f,cancelable,min,max,...)
	Auxiliary.SubGroupCaptured=Group.CreateGroup()
	local min=min or 1
	local max=max or #g
	local ext_params={...}
	local sg=Group.CreateGroup()
	local fg=Duel.GrabSelectedCard()
	if #fg>max or min>max or #(g+fg)<min then return nil end
	for tc in aux.Next(fg) do
		fg:SelectUnselect(sg,tp,false,false,min,max)
	end
	sg:Merge(fg)
	local finish=(#sg>=min and #sg<=max and f(sg,...))
	while #sg<max do
		local cg=Group.CreateGroup()
		local eg=g:Clone()
		for c in aux.Next(g-sg) do
			if not cg:IsContains(c) then
				if Auxiliary.CheckGroupRecursiveCapture(c,sg,eg,f,min,max,ext_params) then
					cg:Merge(Auxiliary.SubGroupCaptured)
				else
					eg:RemoveCard(c)
				end
			end
		end
		cg:Sub(sg)
		finish=(#sg>=min and #sg<=max and f(sg,...))
		if #cg==0 then break end
		local cancel=not finish and cancelable
		local tc=cg:SelectUnselect(sg,tp,finish,cancel,min,max)
		if not tc then break end
		if not fg:IsContains(tc) then
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
				if #sg==max then finish=true end
			else
				sg:RemoveCard(tc)
			end
		elseif cancelable then
			return nil
		end
	end
	if finish then
		return sg
	else
		return nil
	end
end
function Auxiliary.CreateChecks(f,list)
	local checks={}
	for i=1,#list do
		checks[i]=function(c) return f(c,list[i]) end
	end
	return checks
end
function Auxiliary.CheckGroupRecursiveEach(c,sg,g,f,checks,ext_params)
	if not checks[1+#sg](c) then
		return false
	end
	sg:AddCard(c)
	if Auxiliary.GCheckAdditional and not Auxiliary.GCheckAdditional(sg,c,g,f,min,max,ext_params) then
		sg:RemoveCard(c)
		return false
	end
	local res
	if #sg==#checks then
		res=f(sg,table.unpack(ext_params))
	else
		res=g:IsExists(Auxiliary.CheckGroupRecursiveEach,1,sg,sg,g,f,checks,ext_params)
	end
	sg:RemoveCard(c)
	return res
end
function Group.CheckSubGroupEach(g,checks,f,...)
	if f==nil then f=Auxiliary.TRUE end
	if #g<#checks then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	return g:IsExists(Auxiliary.CheckGroupRecursiveEach,1,sg,sg,g,f,checks,ext_params)
end
function Group.SelectSubGroupEach(g,tp,checks,cancelable,f,...)
	if cancelable==nil then cancelable=false end
	if f==nil then f=Auxiliary.TRUE end
	local ct=#checks
	local ext_params={...}
	local sg=Group.CreateGroup()
	local finish=false
	while #sg<ct do
		local cg=g:Filter(Auxiliary.CheckGroupRecursiveEach,sg,sg,g,f,checks,ext_params)
		if #cg==0 then break end
		local tc=cg:SelectUnselect(sg,tp,false,cancelable,ct,ct)
		if not tc then break end
		if not sg:IsContains(tc) then
			sg:AddCard(tc)
			if #sg==ct then finish=true end
		else
			sg:Clear()
		end
	end
	if finish then
		return sg
	else
		return nil
	end
end

function Auxiliary.GetMustMaterialGroup(tp,code)
	local g=Group.CreateGroup()
	local ce={Duel.IsPlayerAffectedByEffect(tp,code)}
	for _,te in ipairs(ce) do
		local tc=te:GetHandler()
		if tc then g:AddCard(tc) end
	end
	return g
end

function Auxiliary.MustMaterialCounterFilter(c,g)
	return not g:IsContains(c)
end

if not IREDO_COMES_TRUE then
	function Card.IsAttackable(c)
		return c:CanAttack()
	end
	Card.IsCanOverlay=aux.TRUE
	Card.IsDualState=Card.IsGeminiState
end

function Auxiliary.linklimit(e,se,sp,st)
	return st&SUMMON_TYPE_LINK==SUMMON_TYPE_LINK
end
function Auxiliary.mzctcheck(g,tp)
	return Duel.GetMZoneCount(tp,g)>0
end
function Auxiliary.mzctcheckrel(g,tp)
	return Duel.GetMZoneCount(tp,g)>0 and Duel.CheckReleaseGroup(tp,Auxiliary.IsInGroup,#g,nil,g)
end
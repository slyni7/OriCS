EFFECT_MULTIPLE_FUSION_MATERIAL=18452701
GlobalMultipleFusionTable={}
SatoneFusionFilter=nil
SatoneFusionEffect=nil
SatoneFusionPlayer=nil
function Auxiliary.MultipleFusionMaterial(c,fc)
	local fe={c:IsHasEffect(EFFECT_MULTIPLE_FUSION_MATERIAL)}
	local res=1
	for _,te in pairs(fe) do
		local v=te:GetValue()
		if type(v)=='number' then
			if v>res then
				res=v
			end
		else
			if v(te,fc)>res then
				res=v(te,fc)
			end
		end
	end
	return res
end
function Auxiliary.AddFusionProcMix(c,sub,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local fun={}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,fc,sub,mg,sg)
				if SatoneFusionFilter and SatoneFusionFilter(c,
					SatoneFusionEffect,SatoneFusionPlayer) then
					return true
				end
				return val[i](c,fc,sub,mg,sg) and not c:IsHasEffect(6205579)
			end
		elseif type(val[i])=='table' then
			fun[i]=function(c,fc,sub,mg,sg)
				if SatoneFusionFilter and SatoneFusionFilter(c,
					SatoneFusionEffect,SatoneFusionPlayer) then
					return true
				end
				for _,fcode in ipairs(val[i]) do
					if type(fcode)=='function' then
						if fcode(c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) then
							return true
						end
					else
						if c:IsFusionCode(fcode) or (sub and c:CheckFusionSubstitute(fc)) then
							return true
						end
					end
				end
				return false
			end
			for _,fcode in ipairs(val[i]) do
				if type(fcode)~='function' then
					mat[fcode]=true
				end
			end
		else
			fun[i]=function(c,fc,sub)
				if SatoneFusionFilter and SatoneFusionFilter(c,
					SatoneFusionEffect,SatoneFusionPlayer) then
					return true
				end
				return c:IsFusionCode(val[i])
					or (sub and c:CheckFusionSubstitute(fc))
			end
			mat[val[i]]=true
		end
	end
	local mt=getmetatable(c)
	if c.material==nil then
		mt.material=mat
	end
	for index,_ in pairs(mat) do
		Auxiliary.AddCodeList(c,index)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FConditionMix(insf,sub,table.unpack(fun)))
	e1:SetOperation(Auxiliary.FOperationMix(insf,sub,table.unpack(fun)))
	c:RegisterEffect(e1)
	mt.fmaterial_used_aux=1
	mt.fmaterial_constant=fun
	mt.alice_minimum=#val
end
function Auxiliary.FConditionMix(insf,sub,...)
	local funs={...}
	return	function(e,g,gc,chkfnf)
				if g==nil then
					return insf
						and Auxiliary.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL)
				end
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=chkfnf&0x100>0
				local concat_fusion=chkfnf&0x200>0
				local sub=(sub or notfusion) and not concat_fusion
				local mg=g:Filter(Auxiliary.FConditionFilterMix,c,c,sub,concat_fusion,table.unpack(funs))
				if gc then
					if not mg:IsContains(gc) then
						return false
					end
					Duel.SetSelectedCard(Group.FromCards(gc))
				end
				GlobalMultipleFusionTable={}
				return mg:CheckSubGroup(Auxiliary.FCheckMixGoal,1,#funs,tp,c,sub,chkfnf,#funs,table.unpack(funs))
			end
end
function Auxiliary.FOperationMix(insf,sub,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=chkfnf&0x100>0
				local concat_fusion=chkfnf&0x200>0
				local sub=(sub or notfusion) and not concat_fusion
				local mg=eg:Filter(Auxiliary.FConditionFilterMix,c,c,sub,concat_fusion,table.unpack(funs))
				if gc then
					Duel.SetSelectedCard(Group.FromCards(gc))
				end
				GlobalMultipleFusionTable={}
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=mg:SelectSubGroup(tp,Auxiliary.FCheckMixGoal,false,1,#funs,tp,c,sub,chkfnf,#funs,table.unpack(funs))
				Duel.SetFusionMaterial(sg)
			end
end
function Auxiliary.FCheckMix(c,mg,sg,fc,sub,ct,fun1,fun2,...)
	if fun2 then
		sg:AddCard(c)
		local res=false
		local mfm=Auxiliary.MultipleFusionMaterial(c,fc)
		local mct=0
		if GlobalMultipleFusionTable[mfm]
			and GlobalMultipleFusionTable[mfm]:IsContains(c) then
			return false
		end
		for i=1,mfm do
			if not GlobalMultipleFusionTable[i] then
				GlobalMultipleFusionTable[i]=Group.CreateGroup()
			end
			if not GlobalMultipleFusionTable[i]:IsContains(c) then
				GlobalMultipleFusionTable[i]:AddCard(c)
				mct=i
				break
			end
		end
		if fun1(c,fc,false,mg,sg) then
			ct=ct-1
			res=mg:IsExists(Auxiliary.FCheckMix,1,nil,mg,sg,fc,sub,ct,fun2,...)
			ct=ct+1
		elseif sub and fun1(c,fc,true,mg,sg) then
			ct=ct-1
			res=mg:IsExists(Auxiliary.FCheckMix,1,nil,mg,sg,fc,false,ct,fun2,...)
			ct=ct+1
		end
		GlobalMultipleFusionTable[mct]:RemoveCard(c)
		sg:RemoveCard(c)
		return res
	else
		local mfm=Auxiliary.MultipleFusionMaterial(c,fc)
		if GlobalMultipleFusionTable[mfm]
			and GlobalMultipleFusionTable[mfm]:IsContains(c) then
			return false
		end
		return ct==1 and fun1(c,fc,sub,mg,sg)
	end
end
function Auxiliary.FCheckMixGoal(sg,tp,fc,sub,chkfnf,ct,...)
	local chkf=chkfnf&0xff
	local concat_fusion=chkfnf&0x200>0
	if not concat_fusion and sg:IsExists(Auxiliary.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then
		return false
	end
	if not Auxiliary.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then
		return false
	end
	local g=Group.CreateGroup()
	return sg:IsExists(Auxiliary.FCheckMix,1,nil,sg,g,fc,sub,ct,...)
		and (chkf==PLAYER_NONE or 
			((fc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
				or (not fc:IsLocation(LOCAION_EXTRA) and Duel.GetMZoneCount(tp,sg,tp)>0)))
		and (not Auxiliary.FCheckAdditional or Auxiliary.FCheckAdditional(tp,sg,fc))
end
function Auxiliary.AddFusionProcMixRep(c,sub,insf,fun1,minc,maxc,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={fun1,...}
	local fun={}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,fc,sub,mg,sg)
				if SatoneFusionFilter and SatoneFusionFilter(c,
					SatoneFusionEffect,SatoneFusionPlayer) then
					return true
				end
				return val[i](c,fc,sub,mg,sg) and not c:IsHasEffect(6205579)
			end
		elseif type(val[i])=='table' then
			fun[i]=function(c,fc,sub,mg,sg)
				if SatoneFusionFilter and SatoneFusionFilter(c,
					SatoneFusionEffect,SatoneFusionPlayer) then
					return true
				end
				for _,fcode in ipairs(val[i]) do
					if type(fcode)=='function' then
						if fcode(c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) then
							return true
						end
					else
						if c:IsFusionCode(fcode) or (sub and c:CheckFusionSubstitute(fc)) then
							return true
						end
					end
				end
				return false
			end
			for _,fcode in ipairs(val[i]) do
				if type(fcode)~='function' then
					mat[fcode]=true
				end
			end
		else
			fun[i]=function(c,fc,sub)
				if SatoneFusionFilter and SatoneFusionFilter(c,
					SatoneFusionEffect,SatoneFusionPlayer) then
					return true
				end
				return c:IsFusionCode(val[i])
					or (sub and c:CheckFusionSubstitute(fc))
			end
			mat[val[i]]=true
		end
	end
	local mt=getmetatable(c)
	if c.material==nil then
		mt.material=mat
	end
	for index,_ in pairs(mat) do
		Auxiliary.AddCodeList(c,index)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FConditionMixRep(insf,sub,fun[1],minc,maxc,table.unpack(fun,2)))
	e1:SetOperation(Auxiliary.FOperationMixRep(insf,sub,fun[1],minc,maxc,table.unpack(fun,2)))
	c:RegisterEffect(e1)
	mt.fmaterial_used_aux=2
	mt.fmaterial_constant={fun[1],minc,maxc,table.unpack(fun,2)}
	mt.alice_minimum=#val+minc-1
end
function Auxiliary.AddFusionProcShaddoll(c,attr)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FShaddollCondition(attr))
	e1:SetOperation(Auxiliary.FShaddollOperation(attr))
	c:RegisterEffect(e1)
	local mt=getmetatable(c)
	mt.fmaterial_used_aux=3
	mt.fmaterial_constant=attr
	mt.alice_minimum=2
end
function Auxiliary.FShaddollFilter(c,fc,attr)
	return (Auxiliary.FShaddollFilter1(c) or Auxiliary.FShaddollFilter2(c,attr))
		and c:IsCanBeFusionMaterial(fc) and not c:IsHasEffect(6205579)
end
function Auxiliary.FShaddollExFilter(c,fc,attr)
	return c:IsFaceup() and Auxiliary.FShaddollFilter(c,fc,attr)
end
function Auxiliary.FShaddollFilter1(c)
	return c:IsFusionSetCard(0x9d) or (SatoneFusionFilter
		and SatoneFusionFilter(c,SatoneFusionEffect,SatoneFusionPlayer))
end
function Auxiliary.FShaddollFilter2(c,attr)
	return c:IsFusionAttribute(attr) or c:IsHasEffect(4904633) or (SatoneFusionFilter
		and SatoneFusionFilter(c,SatoneFusionEffect,SatoneFusionPlayer))
end
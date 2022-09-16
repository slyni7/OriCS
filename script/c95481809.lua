--크로노이드 라이징
local m=95481809
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.tfil11(c)
	return c:IsCanBeFusionMaterial() and c:GetEquipTarget()~=nil
end
function cm.tfil12(c)
	return c:IsHasEffect(95481806)
end
function cm.tfil13(c,e,tp,mg1,mg2,mg3,f,chkf)
	local mg=mg1:Clone()
	if c:IsSetCard(0xd54) then
		mg:Merge(mg2)
	end
	mg:Merge(mg3)
	local sg=mg:Clone()
	return c:IsSetCard(0xd54) and c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and sg:CheckSubGroup(cm.tfun11,1,#sg,e,tp,chkf,c)
end
function cm.tfil14(c,mg)
	return c:IsXyzSummonable(mg,#mg,#mg)
end
function cm.tfun11(g,e,tp,chkf,fc)
	local c=e:GetHandler()
	local t={}
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_BE_FMATERIAL)
		e1:SetRange(tc:GetLocation())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_CHAIN)
		e1:SetTargetRange(1,0)
		tc:RegisterEffect(e1)
		table.insert(t,e1)
		tc=g:GetNext()
	end
	local res=fc:CheckFusionMaterial(g,nil,chkf) and cm.tfun12(g,tp,fc)
		and Duel.IsExistingMatchingCard(cm.tfil14,tp,LOCATION_EXTRA,0,1,fc,g)
	for _,te in ipairs(t) do
		te:Reset()
	end
	return res
end
function cm.tfun12(g,tp,fc)
	local ft=Duel.GetLocationCountFromEx(tp,tp,g,fc)
	if g:IsExists(cm.tfil15,1,nil,tp) or Duel.CheckLocation(tp,LOCATION_MZONE,5) or Duel.CheckLocation(tp,LOCATION_MZONE,6) then
		return ft>=#g
	else
		return ft>#g
	end
end
function cm.tfil15(c,tp)
	return c:GetSequence()>4 and c:IsControler(tp)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(cm.tfil11,tp,LOCATION_SZONE,0,nil)
		local tg=Duel.GetMatchingGroup(cm.tfil12,tp,LOCATION_MZONE,0,nil)
		local mg3=Group.CreateGroup()
		local tc=tg:GetFirst()
		while tc do
			local og=tc:GetOverlayGroup()
			local ug=og:Filter(Card.IsType,nil,TYPE_UNION)
			mg3:Merge(ug)
			tc=tg:GetNext()
		end
		local res=Duel.IsExistingMatchingCard(cm.tfil13,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,mg2,mg3,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg4=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.tfil13,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg4,Group.CreateGroup(),
					Group.CreateGroup(),mf,chkf)
			end
		end
		return res and Duel.IsPlayerCanSpecialSummonCount(tp,3)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function cm.ofil1(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.ofil1,nil,e)
	local mg2=Duel.GetMatchingGroup(cm.tfil11,tp,LOCATION_SZONE,0,nil):Filter(cm.ofil1,nil,e)
	local tg=Duel.GetMatchingGroup(cm.tfil12,tp,LOCATION_MZONE,0,nil)
	local mg3=Group.CreateGroup()
	local tc=tg:GetFirst()
	while tc do
		local og=tc:GetOverlayGroup()
		local ug=og:Filter(Card.IsType,nil,TYPE_UNION):Filter(cm.ofil1,nil,e)
		mg3:Merge(ug)
		tc=tg:GetNext()
	end
	local sg1=Duel.GetMatchingGroup(cm.tfil13,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,mg2,mg3,nil,chkf)
	local mg4=nil
	local sg2=nil
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg4=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c18452712.tfil1,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,Group.CreateGroup(),mf,chkf)
	end
	if #sg1>0 or (sg2~=nil and #sg2>0) then
		local sg=sg1:Clone()
		if sg2 then
			sg:Merge(sg2)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat=nil
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mg=mg1:Clone()
			if tc:IsSetCard(0xd54) then
				mg:Merge(mg2)
			end
			mg:Merge(mg3)
			local tg=mg:Clone()
			local mat1=tg:SelectSubGroup(tp,cm.tfun11,false,1,#tg,e,tp,chkf,tc)
			tc:SetMaterial(mat1)
			mat=mat1
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			mat=mat2
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		if mat:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)==#mat
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>=#mat and Duel.SelectYesNo(tp,aux.Stringid(95481809,2)) then
			Duel.SpecialSummon(mat,0,tp,tp,false,false,POS_FACEUP)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xc=Duel.SelectMatchingCard(tp,cm.tfil14,tp,LOCATION_EXTRA,0,nil,1,1,mat):GetFirst()
			if xc then
				Duel.XyzSummon(tp,xc,mat)
			end
		end
	end
end
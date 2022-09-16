--크로노이드 이볼빙
local m=95481810
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
function cm.tfil11(c,e,tp)
	return c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(cm.tfil12,tp,LOCATION_EXTRA,0,1,c,e,tp,c)
end
function cm.tfil12(c,e,tp,xc)
	local g=Duel.GetMatchingGroup(cm.tfil13,tp,LOCATION_MZONE,0,nil,xc,c)
	return #g>0 and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and g:CheckSubGroup(cm.tfun1,1,#g,e,tp,xc,c)
end
function cm.tfil13(c,xc,fc)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xc) and c:IsCanBeFusionMaterial(fc)
end
function cm.tfun1(g,e,tp,xc,fc)
	local c=e:GetHandler()
	local t={}
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_BE_FMATERIAL)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_CHAIN)
		e1:SetTargetRange(1,0)
		tc:RegisterEffect(e1)
		table.insert(t,e1)
		tc=g:GetNext()
	end
	local res=xc:IsXyzSummonable(g,#g,#g) and fc:CheckFusionMaterial(g,nil,tp)
		and Duel.GetLocationCountFromEx(tp,tp,g,TYPE_FUSION+TYPE_XYZ)>1
	for _,te in ipairs(t) do
		te:Reset()
	end
	return res
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanSpecialSummonCount(tp,2)
			and Duel.IsExistingMatchingCard(cm.tfil11,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xc=Duel.SelectMatchingCard(tp,cm.tfil11,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if not xc then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fc=Duel.SelectMatchingCard(tp,cm.tfil12,tp,LOCATION_EXTRA,0,1,1,xc,e,tp,xc):GetFirst()
	local g=Duel.GetMatchingGroup(cm.tfil13,tp,LOCATION_MZONE,0,nil,xc,fc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local mg=g:SelectSubGroup(tp,cm.tfun1,false,1,#g,e,tp,xc,fc)
	Duel.XyzSummon(tp,xc,mg)
	if fc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) then
		fc:SetMaterial(mg)
		Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		fc:CompleteProcedure()
	end
end
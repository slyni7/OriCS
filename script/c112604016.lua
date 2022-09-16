--평행의 법전
local m=112604016
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetLabel(0)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.filter1(c,e,tp)
	return c:IsSetCard(0xe7c) and c:IsType(TYPE_RITUAL) and not c:IsType(TYPE_SPELL) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetOriginalLevel(),c)
end
function cm.filter2(c,e,tp,lvl,mc)
	return c:IsSetCard(0xe7c) and c:IsType(TYPE_RITUAL) and c:GetOriginalLevel()~=lvl and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,cm.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,cm.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetOriginalLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local lvl=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lvl,nil)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
		end
	end
end
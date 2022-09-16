--剣現する武神
function c95482115.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95482115,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,95482115)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c95482115.target)
	e1:SetOperation(c95482115.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95482115,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,95482115)
	e2:SetLabel(0)
	e2:SetCost(c95482115.cost)
	e2:SetTarget(c95482115.target2)
	e2:SetOperation(c95482115.activate2)
	c:RegisterEffect(e2)
end
function c95482115.spfilter(c,e,tp)
	return c:IsSetCard(0xd5a) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95482115.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c95482115.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c95482115.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95482115.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c95482115.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c95482115.filter1(c,e,tp)
	return c:IsSetCard(0xd5a) and c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(c95482115.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetOriginalAttribute())
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c95482115.filter2(c,e,tp,att)
	return c:IsSetCard(0xd5a) and c:GetOriginalAttribute()~=att and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
end
function c95482115.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c95482115.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c95482115.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetOriginalAttribute())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c95482115.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local att=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95482115.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,att)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
		end
	end
end

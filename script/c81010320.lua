--월하백랑

function c81010320.initial_effect(c)

	--Ritual
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81010320)
	e1:SetTarget(c81010320.sptg)
	e1:SetOperation(c81010320.spop)
	c:RegisterEffect(e1)
	
	--treat Ritual
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010320,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81010321)
	e2:SetCost(c81010320.trco)
	e2:SetTarget(c81010320.trtg)
	e2:SetOperation(c81010320.trop)
	c:RegisterEffect(e2)
	
end

--Ritual
function c81010320.sptgfilter1(c,e,tp,m)
	if not c:IsSetCard(0xca1) or bit.band(c:GetType(),0x81)~=0x81
	or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	return mg:CheckWithSumEqual(c81010320.sptgfilter2,c:GetLevel(),1,99,c)
end
function c81010320.sptgfilter2(c,rc)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank() 
	else
		return c:GetRitualLevel(rc)
	end
end
function c81010320.sptgfilter3(c,e)
	return c:IsReleasable() and not c:IsImmuneToEffect(e) and not c:IsType(TYPE_LINK)
end
function c81010320.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local m=Duel.GetRitualMaterial(tp)
		local g=Duel.GetMatchingGroup(c81010320.sptgfilter3,tp,LOCATION_MZONE,0,nil,e)
		m:Merge(g)
		return Duel.IsExistingMatchingCard(c81010320.sptgfilter1,tp,LOCATION_HAND,0,1,nil,e,tp,m)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function c81010320.spop(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	local g=Duel.GetMatchingGroup(c81010320.sptgfilter3,tp,LOCATION_MZONE,0,nil,e)
	m:Merge(g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c81010320.sptgfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp,m)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		m=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			m=m:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=m:SelectWithSumEqual(tp,c81010320.sptgfilter2,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

--treat Ritual
function c81010320.trcofilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c81010320.trco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				c:IsAbleToRemoveAsCost()
			and Duel.IsExistingMatchingCard(c81010320.trcofilter,tp,LOCATION_GRAVE,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81010320.trcofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c81010320.trtgfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)
	   and ( c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xca1) )
end
function c81010320.trtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c81010320.trtgfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
			end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function c81010320.trop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81010320.trtgfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
	end
end

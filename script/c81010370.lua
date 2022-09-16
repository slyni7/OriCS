--mangetsu-kamen

function c81010370.initial_effect(c)

	--Ritual Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81010370+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81010370.rstg)
	e1:SetOperation(c81010370.rsop)
	c:RegisterEffect(e1)
	
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010370,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c81010370.ngcn)
	e2:SetCost(c81010370.ngco)
	e2:SetTarget(c81010370.ngtg)
	e2:SetOperation(c81010370.ngop)
	c:RegisterEffect(e2)
	
end

--Ritual Summon
function c81010370.rstgfilter0(c)
	return c:IsSetCard(0xca1) and c:GetLevel()>=1 and c:IsAbleToDeck()
end
function c81010370.rstgfilter1(c,e,tp,m)
	if not c:IsSetCard(0xca1) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=m:Filter(c.mat_filter,c)
	else
		mg=m:Clone()
		mg:RemoveCard(c)
	end
	return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function c81010370.rstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsSetCard,nil,0xca1)
		local mg2=Duel.GetMatchingGroup(c81010370.rstgfilter0,tp,LOCATION_GRAVE,0,nil)
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
			mg1:Merge(mg2)
		end
		return Duel.IsExistingMatchingCard(c81010370.rstgfilter1,tp,LOCATION_HAND,0,1,nil,e,tp,mg1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function c81010370.rsop(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsSetCard,nil,0xca1)
	local mg2=Duel.GetMatchingGroup(c81010370.rstgfilter0,tp,LOCATION_GRAVE,0,nil)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
		mg1:Merge(mg2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c81010370.rstgfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1,mg2)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if tc.mat_filter then
			mg1=mg1:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat1=mg1:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
		tc:SetMaterial(mat1)
		local mat2=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		mat1:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat1)
		Duel.SendtoDeck(mat2,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

--negate
function c81010370.ngcnfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca1) and c:IsType(TYPE_MONSTER)
end
function c81010370.ngcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
	and Duel.IsExistingMatchingCard(c81010370.ngcnfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c81010370.ngco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				c:IsAbleToRemoveAsCost()
			end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function c81010370.ngtgfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c81010370.ngtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsLocation(LOCATION_SZONE)
			and chkc:IsControler(1-tp)
			and c81010370.ngtgfilter(chkc)
			end
	if chk==0 then return
				Duel.IsExistingTarget(c81010370.ngtgfilter,tp,0,LOCATION_SZONE,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81010370.ngtgfilter,tp,0,LOCATION_SZONE,1,1,nil)
end

function c81010370.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp)
	then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end

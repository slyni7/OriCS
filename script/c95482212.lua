--라디언트 드바라팔라
function c95482212.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95482212+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95482212.tg1)
	e1:SetOperation(c95482212.op1)
	c:RegisterEffect(e1)
end
function c95482212.fil11(c)
	return c:IsSetCard(0x1d53) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c95482212.fil12(c,e,tp)
	return c:IsSetCard(0xd53)
end
function c95482212.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95482212.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95482212.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95482212.fil11,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local mg=Duel.GetRitualMaterial(tp)
		local g=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,nil,c95482212.fil12,e,tp,mg,nil,Card.GetLevel,"Greater")
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95482212,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			else
				mg:RemoveCard(tc)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
			aux.GCheckAdditional=nil
			if not mat or mat:GetCount()==0 then return end
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end


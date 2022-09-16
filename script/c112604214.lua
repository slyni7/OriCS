--리리컬 BLAST(레이) {순백의 조합법(헌드레드 플러시아)}
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.tar1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
end
function s.nfil111(c,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and c:IsSetCard(0xe79) and Duel.IsExistingMatchingCard(s.nfil112,tp,LOCATION_MZONE,0,1,c,lv)
end
function s.nfil112(c,lv)
	return c:IsLevel(lv) and c:IsFaceup() and c:IsSetCard(0xe79)
end
function s.tfil11(c)
	return c:IsSetCard(0xe79) and not c:IsSetCard(0x1e79) and c:IsAbleToHand()
end
function s.nfil12(c)
	local lv=c:GetLevel()
	return lv==0 and c:IsFaceup() and c:IsSetCard(0xe79)
end
function s.nfil13(c)
	return c:IsFaceup() and c:IsCode(112604200)
end
function s.tfil13(c,e,tp)
	return c:IsSetCard(0xe79) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tfil14(c)
	return c:IsSetCard(0xe79) and c:IsAbleToDeck() and not c:IsPublic()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.nfil111,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(s.tfil11,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.nfil12,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,nil)
	local b3=Duel.IsExistingMatchingCard(s.nfil13,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(s.tfil13,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b4=not Duel.IsExistingMatchingCard(s.nfil111,tp,LOCATION_MZONE,0,1,nil)
		and not Duel.IsExistingMatchingCard(s.nfil12,tp,LOCATION_MZONE,0,1,nil)
		and not Duel.IsExistingMatchingCard(s.nfil13,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.tfil14,tp,LOCATION_HAND,0,1,nil)
	if chk==0 then
		return b1 or b2 or b3 or b4
	end
	local op=aux.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)},
		{b3,aux.Stringid(id,2)},
		{b4,aux.Stringid(id,3)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOGRAVE)
	elseif op==3 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	elseif op==4 then
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
end
function s.ofil14(c)
	return c:IsAbleToDeck() and not c:IsPublic()
end
function s.ofun14(g,e,tp)
	return g:IsExists(s.tfil14,1,nil)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tfil11),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==2 then
		local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND,nil)
		if #g1==0 then
			return
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=g1:RandomSelect(tp,1,1,nil)
		if Duel.SendtoGrave(sg1,REASON_EFFECT)>0 and sg1:GetFirst():IsLocation(LOCATION_GRAVE) then
			local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
			if #g2>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg2=g2:Select(1-tp,1,1,nil)
				Duel.SendtoGrave(sg2,REASON_RULE)
			end
		end
	elseif op==3 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
			return
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.tfil13,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	elseif op==4 then
		local g=Duel.GetMatchingGroup(s.ofil14,tp,LOCATION_HAND,0,nil)
		local sg=aux.SelectUnselectGroup(g,e,tp,1,#g,s.ofun14,1,tp,HINTMSG_TODECK)
		if #sg>0 then
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,#sg+1,REASON_EFFECT)
		end
	end
end
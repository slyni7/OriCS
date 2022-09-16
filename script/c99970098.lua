--[ [ Matryoshka ] ]
local m=99970098
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--소재 보충
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(aux.exccon)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)

end

--특수 소환
function cm.tar1fil(c)
	return c:IsSetCard(0xd37) and c:IsAbleToDeck()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.tar1fil,tp,LSTN("G"),0,nil)
	mg:Merge(Duel.GetOverlayGroup(tp,1,1):Filter(cm.tar1fil,nil))
	if chk==0 then return #mg>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LSTN("GX"))
end
function cm.op1fil(c,e,tp,lv)
	if not (c:IsSetCard(0xd37) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(lv)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mg=Duel.GetMatchingGroup(cm.tar1fil,tp,LSTN("G"),0,nil)
	mg:Merge(Duel.GetOverlayGroup(tp,1,1):Filter(cm.tar1fil,nil))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=mg:Select(tp,1,5,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		local dg=Duel.GetMatchingGroup(cm.op1fil,tp,LOCATION_DECK,0,nil,e,tp,ct+1)
		if ct>0 and #dg>0 then
			Duel.BreakEffect()
			local tc=dg:Select(tp,1,1,nil):GetFirst()
			if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0
				or Duel.SelectOption(tp,1190,1152)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end		
	end
end

--소재 보충
function cm.tar2fil(c)
	return c:IsFaceup() and c:IsSetCard(0xd37)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.tar2fil(chkc) end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
		and Duel.IsExistingTarget(cm.tar2fil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.tar2fil,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	g:Merge(Duel.GetDecktopGroup(1-tp,1))
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,g)
	end
end

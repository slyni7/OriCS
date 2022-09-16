--[ [ Matryoshka ] ]
local m=99970085
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환 + 서치
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetCL(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	
	--서치 부여
	local e2=MakeEff(c,"XFTo","M")
	e2:SetD(m,0)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCL(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
end

--특수 소환 + 서치
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.tar1fil(c)
	return c:IsSetCard(0xd37) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(cm.tar1fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tar1fil,tp,LOCATION_DECK,0,nil)
	if not c:IsRelateToEffect(e) or #g<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

--서치
function cm.tar2fil(c,lv)
	return c:IsSetCard(0xd37) and not c:IsLevel(lv) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar2fil,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tar2fil,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler():GetLevel())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

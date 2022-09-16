--[ [ Matryoshka ] ]
local m=99970099
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e0=Effect.CreateEffect(c)
	e0:SetD(m,3)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	--회수
	local e1=MakeEff(c,"Qo","S")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=MakeEff(c,"Qo","HS")
	e2:SetD(m,2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1,m)
	e2:SetCost(aux.bfgcost)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
end

--회수
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0xd37),tp,LOCATION_MZONE,0,1,nil)
end
function cm.tar1fil(c,e,tp)
	return c:IsAbleToHand()
		or (c:IsSetCard(0xd37) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetOverlayGroup(tp,1,1):Filter(cm.tar1fil,nil):GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetOverlayGroup(tp,1,1):Filter(cm.tar1fil,nil):Select(tp,1,1,nil):GetFirst()
	if tc then
		if tc:IsSetCard(0xd37) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end

--특수 소환
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetOverlayCount(tp,1,1)==0
end
function cm.tar2fil(c,e,tp)
	return c:IsLevelAbove(5) and c:IsSetCard(0xd37) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.tar2fil,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tar2fil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetD(m,4)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e3:SetTargetRange(1,0)
		e3:SetTarget(cm.splimit)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function cm.splimit(e,c)
	return not c:IsSetCard(0xd37)
end

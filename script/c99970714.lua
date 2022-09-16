--[ Lava Golem ]
local m=99970714
local cm=_G["c"..m]
function cm.initial_effect(c)

	--라바 골렘
	YuL.AddLavaGolemProcedure(c,cm.con0,m)
	
	--특수 소환 + 번
	local e1=MakeEff(c,"FTf","M")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCL(1)
	e1:SetCondition(YuL.turn(0))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--파괴 회피
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(cm.reptg)
	e2:SetCL(1)
	c:RegisterEffect(e2)
	
	--자가 회수
	local e3=MakeEff(c,"STo")
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(spinel.delay)
	e3:SetCL(1,m)
	e3:SetCondition(aux.PreOnfield)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	
end

--라바 골렘
function cm.con0(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)<=3
end

--특수 소환 + 번
function cm.tar1fil(c,e,tp)
	return c:IsLavaGolemCard() and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.tar1fil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then 
			if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetOperation(cm.thop)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetCountLimit(1)
				tc:RegisterEffect(e1,true)
			end
		else Duel.Damage(tp,1000,REASON_EFFECT) end
	end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(1-tp,cm.tar1fil,1-tp,LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			if Duel.SpecialSummonStep(tc,0,1-tp,1-tp,true,false,POS_FACEUP_ATTACK) then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetOperation(cm.thop)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetCountLimit(1)
				tc:RegisterEffect(e2,true)
			end
		else Duel.Damage(1-tp,1000,REASON_EFFECT) end
	end
	Duel.SpecialSummonComplete()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end

--파괴 회피
function cm.repfilter(c)
	return c:IsLavaGolemCard() and c:IsAbleToGrave()
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(cm.repfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.repfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
		return true
	else return false end
end

--자가 회수
function cm.cost3fil(c)
	return c:IsLavaGolem() and c:IsAbleToDeckAsCost()
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cost3fil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cost3fil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,c)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

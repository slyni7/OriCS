--　(키사라기) ◆ 하스미(ONESELF)
local m=112604276
local cm=_G["c"..m]
function cm.initial_effect(c)

	--spirit return
	Spirit.AddProcedure(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP,EVENT_SPSUMMON_SUCCESS)

	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_HAND)
	e6:SetCountLimit(1,m,EFFECT_COUNT_CODE_OATH)
	e6:SetCost(cm.spcost)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
	
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,{m,1},EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(kaos.ksrgcon1)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_TO_GRAVE)
	e9:SetCategory(CATEGORY_TOGRAVE)
	e9:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e9:SetCondition(kaos.ksrgcon2)
	e9:SetTarget(cm.destg)
	e9:SetOperation(cm.desop)
	c:RegisterEffect(e9)
	
end

--spsummon
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.CheckLPCost(tp,600) end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	Duel.PayLPCost(tp,600)
end
function cm.spfilter(c,e,tp)
	return (c:IsSetCard(0xe92) or c:IsSetCard(0xe75)) and not c:IsLevel(7,8)
		and not c:IsCode(m) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsAbleToGrave())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToGrave() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(tc:GetRace())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end

--draw
function cm.spfilter9(c,e,tp)
	return c:IsType(TYPE_SPIRIT) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local tg=Duel.GetMatchingGroup(cm.spfilter9,tp,LOCATION_HAND,0,nil,e,tp)
		if tg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=tg:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end


--destroy
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
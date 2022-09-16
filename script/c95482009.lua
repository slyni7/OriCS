--순환의 비전술
function c95482009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95482009+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c95482009.cost)
	e1:SetTarget(c95482009.target)
	e1:SetOperation(c95482009.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(95482009,ACTIVITY_CHAIN,c95482009.chainfilter)
end
function c95482009.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0xd40) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY)
end
function c95482009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetCustomActivityCount(95482009,tp,ACTIVITY_CHAIN)<3 end
end
function c95482009.filter(c)
	return c:IsSetCard(0xd40) and (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_QUICKPLAY+TYPE_SPELL) and c:IsAbleToHand() and not c:IsCode(95482009)
end
function c95482009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c95482009.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95482009.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c95482009.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c95482009.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tc)
		local ct=Duel.GetCustomActivityCount(95482009,tp,ACTIVITY_CHAIN)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			ct=ct-1
		end
		local te=tc:CheckActivateEffect(true,true,false)
		if (ct>=1 and te~=nil) or (ct>=2 and c:IsRelateToEffect(e) and c:IsCanTurnSet()) then
			if ct>=1 and te~=nil and Duel.SelectYesNo(tp,aux.Stringid(95482009,0)) then
				local co=te:GetCost()
				local tg=te:GetTarget()
				local op=te:GetOperation()
				e:SetCategory(te:GetCategory())
				e:SetProperty(te:GetProperty())
				tc:CreateEffectRelation(te)
				if tg then
					tg(te,tp,eg,ep,ev,re,r,rp,1)
				end
				Duel.BreakEffect()
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				local etc=nil
				if g then
					etc=g:GetFirst()
					while etc do
						etc:CreateEffectRelation(te)
						etc=g:GetNext()
					end
				end
				if op and not tc:IsDisabled() then
					op(te,tp,eg,ep,ev,re,r,rp)
				end
				tc:ReleaseEffectRelation(te)
				if g then
					etc=g:GetFirst()
					while etc do
						etc:ReleaseEffectRelation(te)
						etc=g:GetNext()
					end
				end
				e:SetCategory(0)
				e:SetProperty(0)
			end
			if ct>=2 and c:IsRelateToEffect(e) and c:IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(95482009,1)) then
				Duel.BreakEffect()
				c:CancelToGrave()
				Duel.ChangePosition(c,POS_FACEDOWN)
				Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			end
		end
	end
end

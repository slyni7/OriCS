--치노화!
function c84320042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,84320042)
	e1:SetCost(c84320042.cost)
	e1:SetTarget(c84320042.target)
	e1:SetOperation(c84320042.activate)
	c:RegisterEffect(e1)
end
function c84320042.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c84320042.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c84320042.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Exile then
			if Duel.Exile(tc,REASON_EFFECT)>0 then
				local chain=Duel.GetCurrentChain()
				for i=1,chain-1 do
					local ce=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
					local cc=ce:GetHandler()
					if tc==cc then
						tc:ReleaseEffectRelation(ce)
					end
				end
			end
		elseif EFFECT_FUSION_MAT_RESTRICTION then
			Duel.SendtoDeck(tc,nil,-2,REASON_EFFECT)
		else
			if not tc:IsImmuneToEffect(e) then
				Duel.Delete(e,tc)
			end
		end
	end
end

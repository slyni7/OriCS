--이레귤러: 알터 리얼리티
function c95480610.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,95480610)
	e1:SetCost(c95480610.cost)
	e1:SetTarget(c95480610.target)
	e1:SetOperation(c95480610.activate)
	c:RegisterEffect(e1)
end
function c95480610.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c95480610.filter1(c,e,tp)
	return c:IsLevelBelow(3) and c:IsRace(RACE_PSYCHO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480610.filter2(c)
	return c:IsRace(RACE_PSYCHO) and c:IsFaceup() and c:IsAbleToHand()
end
function c95480610.filter3(c,tp)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToRemove() and Duel.IsPlayerCanDraw(tp,1)
end
function c95480610.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c95480610.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c95480610.filter2,tp,LOCATION_REMOVED,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c95480610.filter3,tp,LOCATION_GRAVE,0,1,nil,tp)
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(91501248,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(91501248,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(91501248,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
	elseif sel==2 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
	else
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c95480610.drfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToRemove()
end
function c95480610.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local c=e:GetHandler()
		local fid=c:GetFieldID()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c95480610.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(95480610,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(tc)
			e1:SetCondition(c95480610.rmcon)
			e1:SetOperation(c95480610.rmop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c95480610.filter2,tp,LOCATION_REMOVED,0,1,2,nil)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
		if sg and sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	else
		if not Duel.IsPlayerCanDraw(tp) then return end
		local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		if ct==0 then ct=1 end
		if ct>2 then ct=2 end
		local g=Duel.SelectMatchingCard(tp,c95480610.drfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			local rct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			Duel.Draw(tp,rct,REASON_EFFECT)
		end
	end
end
function c95480610.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(95480610)==e:GetLabel()
end
function c95480610.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end

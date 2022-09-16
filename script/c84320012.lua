--아메에서 시작하는 유키구름
function c84320012.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c84320012.target)
	e1:SetOperation(c84320012.operation)
	c:RegisterEffect(e1)
end
function c84320012.filter1(c,e,tp)
	return c:IsSetCard(0x7a0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84320012.filter2(c,e,tp)
	return c:IsSetCard(0x7a0) and c:IsFaceup()
end
function c84320012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	local c=e:GetHandler()
	local b1=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil)>0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c84320012.filter1,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b3=Duel.IsExistingTarget(c84320012.filter2,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,TYPE_SPELL+TYPE_TRAP)
	if chk==0 then
		e:SetLabel(0)
		return b1 or b2 or b3
	end
	e:SetLabel(0)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then
		return
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(opval[op])
	if opval[op]==1 then
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	elseif opval[op]==3 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectTarget(tp,c84320012.filter2,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,TYPE_SPELL+TYPE_TRAP)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	end
end
function c84320012.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil)
		local tc=g:GetFirst()
		while tc do
			tc:AddCounter(0x1234,1)
			tc=g:GetNext()
		end
	elseif op==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c84320012.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==3 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
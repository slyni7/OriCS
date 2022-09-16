--드라코센드 카니라
function c95480517.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c95480517.ctop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95480517,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,95480517)
	e3:SetTarget(c95480517.destg)
	e3:SetOperation(c95480517.desop)
	c:RegisterEffect(e3)
	if c95480517.counter==nil then
		c95480517.counter=true
		c95480517[0]=0
		c95480517[1]=0
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e4:SetOperation(c95480517.resetcount)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_SPSUMMON_SUCCESS)
		e5:SetOperation(c95480517.addcount)
		Duel.RegisterEffect(e5,0)
	end
end
function c95480517.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c95480517[0]=0
	c95480517[1]=0
end
function c95480517.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetOriginalRace()==RACE_WYRM and tc:IsType(TYPE_MONSTER) then
			c95480517[1-tc:GetSummonPlayer()]=c95480517[1-tc:GetSummonPlayer()]+1
		end
		tc=eg:GetNext()
	end
end
function c95480517.ctfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0xd5b)
end
function c95480517.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c95480517.ctfilter,1,nil,tp) then
		Duel.Hint(HINT_CARD,0,95480517)
		Duel.Damage(1-tp,c95480517[tp]*100,REASON_EFFECT)
		Duel.Recover(tp,c95480517[tp]*100,REASON_EFFECT)
	end
end
function c95480517.desfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WYRM) and c:IsLinkState()
end
function c95480517.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c95480517.desfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c95480517.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c95480517.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(g,REASON_EFFECT)~=2 then
		local g2=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95480517,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,REMOVE)
			local sg=g2:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
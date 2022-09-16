--¿µ¸ÅÈñ Ã÷Ä¡±¸¸ð
function c95480913.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95480913,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,95480913)
	e2:SetTarget(c95480913.destg)
	e2:SetOperation(c95480913.desop)
	c:RegisterEffect(e2)
	--disable spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(14309486,3))
	e4:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON)
	e4:SetCountLimit(1,95480987)
	e4:SetCondition(c95480913.negcon)
	e4:SetTarget(c95480913.negtg)
	e4:SetOperation(c95480913.negop)
	c:RegisterEffect(e4)
end
function c95480913.thfilter(c)
	return c:IsSetCard(0xd42) and c:IsAbleToHand() and c:IsType(TYPE_PENDULUM)
end
function c95480913.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c95480913.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95480913.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c95480913.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		local c=e:GetHandler()
		local tc=g:GetFirst()
		if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LSCALE)
			e1:SetValue(tc:GetLeftScale())
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_RSCALE)
			e2:SetValue(tc:GetRightScale())
			c:RegisterEffect(e2)
		end
	end
end
function c95480913.negcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c95480913.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,nil,0xd42) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c95480913.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,nil,0xd42)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

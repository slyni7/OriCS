--영매사 토라
function c95480902.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95480902,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c95480902.sctg)
	e1:SetOperation(c95480902.scop)
	c:RegisterEffect(e1)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95480902,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,95480902)
	e3:SetTarget(c95480902.target)
	e3:SetOperation(c95480902.operation)
	c:RegisterEffect(e3)
end
function c95480902.scfilter(c,pc)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xd42) and not c:IsPublic() and c:GetLeftScale()~=pc:GetLeftScale()
end
function c95480902.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480902.scfilter,tp,LOCATION_HAND,0,1,nil,e:GetHandler()) end
end
function c95480902.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c95480902.scfilter,tp,LOCATION_HAND,0,1,1,nil,c)
	local tc=g:GetFirst()
	  if tc then
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
function c95480902.filter(c)
	return c:IsSetCard(0xd42) and not c:IsCode(95480902) and c:IsAbleToHand() and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
end
function c95480902.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480902.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c95480902.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95480902.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--招来の対価
function c84320032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,84320032)
	e1:SetTarget(c84320032.target)
	e1:SetOperation(c84320032.activate)
	c:RegisterEffect(e1)
	if c84320032.global_effect==nil then
		c84320032.global_effect=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_DESTROY)
		e1:SetOperation(c84320032.addcount)
		Duel.RegisterEffect(e1,0)
	end
end
function c84320032.addcount(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	while c~=nil do
		if not c:IsType(TYPE_TOKEN) then
			local p=c:GetReasonPlayer()
			Duel.RegisterFlagEffect(p,84320032,RESET_PHASE+PHASE_END,0,1)
		end
		c=eg:GetNext()
	end
end
function c84320032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) end
end
function c84320032.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c84320032.effectcon)
	e1:SetOperation(c84320032.effectop)
	Duel.RegisterEffect(e1,tp)
end
function c84320032.effectcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,84320032)>0
end
function c84320032.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c84320032.filter2(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c84320032.effectop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,84320032)
	local ct=Duel.GetFlagEffect(tp,84320032)
	if ct>=1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif ct>=2 then
		local g=Duel.GetMatchingGroup(c84320032.filter1,tp,LOCATION_GRAVE,0,nil)
		if g:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=g:Select(tp,2,2,nil)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	else
		local g=Duel.GetMatchingGroup(c84320032.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local tg=g:Select(tp,1,3,nil)
			Duel.Destroy(tg,REASON_EFFECT)
		end
	end
end

--요녀

function c81010380.initial_effect(c)

	--Ritual Material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(c81010380.rilv)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,81010380)
	e2:SetCondition(c81010380.rmcn)
	e2:SetTarget(c81010380.rmtg)
	e2:SetOperation(c81010380.rmop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(c81010380.rmcn2)
	c:RegisterEffect(e3)
end

--Ritual Material
function c81010380.rilv(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0xca1) then
		local clv=c:GetLevel()
		return lv*0x10000+clv
	else
		return lv 
	end
end

--
function c81010380.rmcn(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 
	   and re:GetHandler():IsSetCard(0xca1)
end
function c81010380.rmcn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST)	and re:IsHasType(0x7e0) 
	and re:GetHandler():IsSetCard(0xca1)
end

function c81010380.shtgfilter(c)
	return c:IsLevelBelow(5)
	   and ( c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xca1) )
	   and c:IsAbleToHand()
end
function c81010380.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(c81010380.shtgfilter,tp,LOCATION_DECK,0,1,nil) then sel=sel+1 end
		if c:IsAbleToHand() then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0 and Duel.IsPlayerCanDraw(tp,1)
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81010380,0))
		sel=Duel.SelectOption(tp,aux.Stringid(81010380,1),aux.Stringid(81010380,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(81010380,1))
	else
		Duel.SelectOption(tp,aux.Stringid(81010380,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
		
function c81010380.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		if c:IsRelateToEffect(e) then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c81010380.shtgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

		
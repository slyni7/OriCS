--MMJ : Set-Tou
function c81010180.initial_effect(c)
	
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1160)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c81010180.reg)
	c:RegisterEffect(e1)
	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,81010180)
	e2:SetCondition(c81010180.thcn)
	e2:SetTarget(c81010180.thtg)
	e2:SetOperation(c81010180.thop)
	c:RegisterEffect(e2)
	
	--summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c81010180.pslimit)
	c:RegisterEffect(e3)
	
	--revive
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81010180,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,81010181)
	e4:SetCost(c81010180.rvco)
	e4:SetTarget(c81010180.rvtg)
	e4:SetOperation(c81010180.rvop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e5)

end

--activate
function c81010180.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(81010180,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

--search
function c81010180.thcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(81010180)~=0
end

function c81010180.thtgfilter(c)
	return c:IsSetCard(0xca1) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c81010180.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010180.thtgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81010180.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINT_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81010180.thtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


--pendulum summon limit
function c81010180.pslimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0xca1) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end


--revive
function c81010180.rvcofilter(c)
	return c:IsSetCard(0xca1) and c:IsFaceup() and c:IsAbleToRemoveAsCost() and not c:IsCode(81010180)
end
function c81010180.rvco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010180.rvcofilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81010180.rvcofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c81010180.rvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function c81010180.rvop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end

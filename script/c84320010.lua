--유키-시작은 혼자서
function c84320010.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c84320010.con)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c84320010.atktg)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetRange(LOCATION_PZONE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetOperation(c84320010.operation)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(84320010,0))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetOperation(c84320010.addc)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--search
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(84320010,2))
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_LEAVE_FIELD)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e8:SetCondition(c84320010.spcon)
	e8:SetTarget(c84320010.sptg)
	e8:SetOperation(c84320010.spop)
	c:RegisterEffect(e8)
	--to deck
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_REMOVE)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_EXTRA)
	e8:SetCost(c84320010.thcost)
	e8:SetTarget(c84320010.destg)
	e8:SetOperation(c84320010.desop)
	c:RegisterEffect(e8)
end
function c84320010.atktg(e,c)
	return c:IsSetCard(0x7a0)
end


function c84320010.con(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end



function c84320010.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1234,1)
		tc=g:GetNext()
	end
end


function c84320010.addc(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1234,1)
		tc=g:GetNext()
	end
end







function c84320010.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c84320010.filter(c,e,tp)
	return c:IsSetCard(0x7a0) or c:IsCode(59438930) or c:IsCode(55623480) 
		 and c:IsAbleToHand()
		 and (not c:IsLocation(LOCATION_GRAVE) or not c:IsHasEffect(EFFECT_NECRO_VALLEY))
end
function c84320010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84320010.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c84320010.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c84320010.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c84320010.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and e:GetHandler():IsLocation(LOCATION_EXTRA) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.RemoveCounter(tp,1,1,0x1234,10,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
end
function c84320010.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_HAND)
end
function c84320010.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		Duel.ShuffleHand(1-p)
	end
end
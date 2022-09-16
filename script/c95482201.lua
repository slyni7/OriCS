--드바라팔라딘 마나흐
function c95482201.initial_effect(c)
	--token&heffect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(52840267,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,95482201)
	e1:SetCost(c95482201.cost1)
	e1:SetTarget(c95482201.tg1)
	e1:SetOperation(c95482201.op1)
	c:RegisterEffect(e1)
	--bfg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(52840267,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,95482299)
	e2:SetCost(c95482201.cost2)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c95482201.tg2)
	e2:SetOperation(c95482201.op2)
	c:RegisterEffect(e2)
end

function c95482201.cfil1(c)
	return c:IsSetCard(0xd53) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c95482201.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c95482201.cfil1,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c95482201.cfil1,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function c95482201.fil1(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function c95482201.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.GetLocationCount(tp,LOCATION_MZONE)~=0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,95482200,0xd53,TYPES_TOKEN_MONSTER,2000,2000,6,RACE_ROCK,ATTRIBUTE_LIGHT)
		and Duel.IsExistingMatchingCard(c95482201.fil1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c95482201.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,95482200,0xd53,TYPES_TOKEN_MONSTER,2000,2000,6,RACE_ROCK,ATTRIBUTE_LIGHT) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95482201.fil1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local token=Duel.CreateToken(tp,95482200)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_EXTRA))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c95482201.cfil2(c)
	return c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(true,true,false)~=nil
end
function c95482201.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c95482201.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c95482201.cfil2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c95482201.cfil2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local te=g:GetFirst():CheckActivateEffect(true,true,false)
	e:SetLabelObject(te)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c95482201.op2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
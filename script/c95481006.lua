--에테리얼 아니마기아스
function c95481006.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,95481006)
	e2:SetCost(c95481006.spcost)
	e2:SetTarget(c95481006.sptg)
	e2:SetOperation(c95481006.spop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c95481006.effcon)
	e3:SetOperation(c95481006.effop)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(48686504,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,95481056)
	e4:SetCondition(c95481006.condition)
	e4:SetCost(c95481006.cost2)
	e4:SetTarget(c95481006.target2)
	e4:SetOperation(c95481006.operation2)
	c:RegisterEffect(e4)
end
function c95481006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function c95481006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c95481006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsPreviousLocation(LOCATION_GRAVE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end

function c95481006.cfilter(c)
	return c:IsFaceup() and c:IsCode(95481011)
end
function c95481006.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c95481006.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c95481006.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd5e) and not c:IsCode(95481006) and c:IsAbleToHand()
end
function c95481006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c95481006.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95481006.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c95481006.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c95481006.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c95481006.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c95481006.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(95481505,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95481094)
	e1:SetTarget(c95481006.rmtg)
	e1:SetOperation(c95481006.rmop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c95481006.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c95481006.costfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xd5e) and c:IsLevelBelow(4) and not c:IsType(TYPE_TUNER) and Duel.GetMZoneCount(tp,c,tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,95481019,0xd5e,0x4011,0,0,1,RACE_WATER,ATTRIBUTE_WATER)
end
function c95481006.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c95481006.costfilter,1,e:GetHandler(),e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c95481006.costfilter,1,1,e:GetHandler(),e,tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c95481006.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=e:GetLabel()
	if ft>0 and ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,95481019,0xd5e,0x4011,0,0,1,RACE_WATER,ATTRIBUTE_WATER) then
		local count=math.min(ft,ct)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then count=1 end
		if count>1 then
			local num={}
			local i=1
			while i<=count do
				num[i]=i
				i=i+1
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(85243784,1))
			count=Duel.AnnounceNumber(tp,table.unpack(num))
		end
		repeat
			local token=Duel.CreateToken(tp,95481019)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			count=count-1
		until count==0
		Duel.SpecialSummonComplete()
	end
end


function c95481006.gspfilter(c,tp)
	return c:IsCode(95481011) and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp,true,true))
end
function c95481006.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481006.gspfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95481006.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
	local g=Duel.SelectMatchingCard(tp,c95481006.gspfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.ResetFlagEffect(tp,15248873)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		local b1=tc:IsAbleToHand()
		if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
		local b2=te:IsActivatable(tp,true,true)
		Duel.ResetFlagEffect(tp,15248873)
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1150)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end

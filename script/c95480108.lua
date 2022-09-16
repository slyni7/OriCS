--알피스트 에퀴녹스로프
function c95480108.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c95480108.atkcon)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--change name
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetValue(95482101)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95480101,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,95480108)
	e4:SetTarget(c95480108.thtg)
	e4:SetOperation(c95480108.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c95480108.thcon)
	c:RegisterEffect(e5)
end
function c95480108.atkcon(e)
	return e:GetHandler():IsLinkState()
end

function c95480108.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg1=Duel.GetLinkedGroup(tp,1,1)
	local lg2=Duel.GetLinkedGroup(1-tp,1,1)
	lg1:Merge(lg2)
	return lg1 and lg1:IsContains(e:GetHandler())
end
function c95480108.setfilter(c,e,tp,mft,sft)
	return (sft>0 and c:IsSSetable(true) or mft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
		and (c:IsFaceup() or c:IsLocation(LOCATION_DECK+LOCATION_GRAVE))
end
function c95480108.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local sft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		return Duel.IsExistingMatchingCard(c95480108.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,mft,sft)
	end
end
function c95480108.thop(e,tp,eg,ep,ev,re,r,rp)
	local mft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c95480108.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,tc1,e,tp,mft,sft):GetFirst()
	if tc:IsType(TYPE_MONSTER) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	else
		Duel.SSet(tp,tc,tp,false)
	end
	Duel.ConfirmCards(1-tp,tc)
end

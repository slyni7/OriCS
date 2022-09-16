--천승자 에퀴녹스
function c95480101.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95480101,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,95480101)
	e1:SetTarget(c95480101.thtg)
	e1:SetOperation(c95480101.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c95480101.thcon)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetOperation(c95480101.effop)
	c:RegisterEffect(e3)
end

function c95480101.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg1=Duel.GetLinkedGroup(tp,1,1)
	local lg2=Duel.GetLinkedGroup(1-tp,1,1)
	lg1:Merge(lg2)
	return lg1 and lg1:IsContains(e:GetHandler())
end
function c95480101.filter(c)
	return (c:IsSetCard(0xd5f) or c:IsSetCard(0xd55)) and c:IsType(TYPE_MONSTER) and not c:IsCode(95480101) and c:IsAbleToGrave()
end
function c95480101.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c95480101.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c95480101.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c95480101.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,tp)
	local lv=g:GetFirst():GetLevel()
end
function c95480101.thfilter(c)
	return (c:IsSetCard(0xd5f) or c:IsSetCard(0xd55)) and c:IsAbleToHand()
end
function c95480101.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=tc:GetLevel()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=lv then return end
	Duel.ConfirmDecktop(tp,lv)
	local g=Duel.GetDecktopGroup(tp,lv)
	local ct=g:GetCount()
	if ct>0 and g:FilterCount(c95480101.thfilter,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(47674738,2)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c95480101.thfilter,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		ct=g:GetCount()-sg:GetCount()
	end
	if ct>0 then
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
end

function c95480101.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(95480101,1))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c95480101.chcon)
	e1:SetOperation(c95480101.chop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95480101,2))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0xd5f)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e3,true)
	local e4=e3:Clone()
	e4:SetValue(0xd55)
	rc:RegisterEffect(e4,true)
end
function c95480101.chcon(e)
	return e:GetHandler():IsLinkState()
end
function c95480101.chop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(c95480101.chlimit)
end
function c95480101.chlimit(e,ep,tp)
	return ep==tp
end
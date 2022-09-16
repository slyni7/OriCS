--이레귤러: 싱귤러리티
function c95480605.initial_effect(c)
	--deck check
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47077318,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,95480605)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c95480605.cost)
	e1:SetTarget(c95480605.target)
	e1:SetOperation(c95480605.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(38572779,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,95480695)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c95480605.spcost)
	e2:SetTarget(c95480605.sptg)
	e2:SetOperation(c95480605.spop)
	c:RegisterEffect(e2)
end
function c95480605.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c95480605.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c95480605.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsRace(RACE_PLANT) then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	else
		Duel.MoveSequence(tc,1)
	end
end
function c95480605.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c95480605.cfilter(c)
	return c:IsSetCard(0xd57) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c95480605.spfilter(c,e,tp,lv)
	return c:IsSetCard(0xd57) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480605.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local cg=Duel.GetMatchingGroup(c95480605.cfilter,tp,LOCATION_GRAVE,0,nil)
		return c:IsAbleToRemoveAsCost()
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c95480605.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,cg:GetCount())
	end
	local cg=Duel.GetMatchingGroup(c95480605.cfilter,tp,LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroup(c95480605.spfilter,tp,LOCATION_DECK,0,nil,e,tp,cg:GetCount())
	local lvt={}
	local tc=tg:GetFirst()
	while tc do
		local tlv=0
		tlv=tlv+tc:GetLevel()
		lvt[tlv]=tlv
		tc=tg:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(95480605,2))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	local rg1=Group.CreateGroup()
	if lv>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg2=cg:Select(tp,lv-1,lv-1,c)
		rg1:Merge(rg2)
	end
	rg1:AddCard(c)
	Duel.Remove(rg1,POS_FACEUP,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c95480605.sfilter(c,e,tp,lv)
	return c:IsSetCard(0xd57) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480605.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95480605.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(95480605,RESET_EVENT+0x1fe0000,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c95480605.descon)
		e1:SetOperation(c95480605.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c95480605.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(95480605)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c95480605.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end

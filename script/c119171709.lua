--소울 슬레이어의 전장
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tar1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	--Special Summon a Wyrm monster from the Deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)

	--마법 & 함정 존 발동
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_ACTIVATE_COST)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,1)
	e0:SetCost(s.cost0)
	e0:SetTarget(s.tar0)
	e0:SetOperation(s.op0)
	c:RegisterEffect(e0)
end
--마법 & 함정 존 발동
function s.cost0(e,te,tp)
	return true
end
function s.tar0(e,te,tp)
	local c=e:GetHandler()
	local tc=te:GetHandler()
	return te:IsHasType(EFFECT_TYPE_IGNITION) and c==tc
end
function s.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
end
function s.descfilter(c)
	return c:IsSetCard(0x903)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not c:IsLocation(LOCATION_GRAVE)
			or Duel.CheckReleaseGroupCost(tp,s.descfilter,1,false,nil,nil)
	end
	if c:IsPreviousLocation(LOCATION_GRAVE) then
		local sg=Duel.SelectReleaseGroupCost(tp,s.descfilter,1,1,false,nil,nil)
		Duel.Release(sg,REASON_COST)
	end
end
function s.tfil11(c)
	return c:IsSetCard(0x903) and c:IsAbleToGrave()
end
function s.tfil12(c,e,tp)
	return c:IsSetCard(0x903) and
		((c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
			or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or c:IsAbleToHand())
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.tfil11,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(s.tfil12,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tfil11,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.tfil12,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=sg:GetFirst()
		if tc:IsMonster() then
			if tc:IsAbleToHand() and (Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
				or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
				or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			end
		elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
			if tc:IsAbleToHand() and (Duel.GetLocationCount(tp,LOCATION_SZONE)<=0
				or not tc:IsSSetable()
				or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			else
				Duel.SSet(tp,tc)
			end
		end
	end
end
function s.cfilter(c,p)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==p
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.cfilter,nil,1-tp)
	e:SetLabel(#g)
	return #g>0
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x903) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetLabel()>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--ゼリッピの森
function c112400020.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,112400020+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e0)
	--re0(summon limit)
	Duel.AddCustomActivityCounter(112400020,ACTIVITY_SUMMON,c112400020.counterfilter)
	Duel.AddCustomActivityCounter(112400020,ACTIVITY_SPSUMMON,c112400020.counterfilter)
	--e1(def up)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(c112400020.counterfilter))
	e1:SetValue(c112400020.defvalue)
	c:RegisterEffect(e1)
	--e2(search)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112400020,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c112400020.thcost)
	e2:SetTarget(c112400020.thtg)
	e2:SetOperation(c112400020.thop)
	c:RegisterEffect(e2)
	--e3(spsummon)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112400020,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c112400020.descost)
	e3:SetTarget(c112400020.destg)
	e3:SetOperation(c112400020.desop)
	c:RegisterEffect(e3)
end
c112400020.listed_series={0x4ec1,0x8ec1}
c112400020.listed_names={112400020}
c112400020.card_code_list={[112400020]=true}
--re1(summon limit)
function c112400020.counterfilter(c)
	return c:IsSetCard(0x4ec1) or c:IsSetCard(0x8ec1)
end
function c112400020.splimit(e,c)
	return not c:IsSetCard(0x4ec1) and not c:IsSetCard(0x8ec1)
end
--e1(def up)
function c112400020.deffilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4ec1) and c:GetLevel()~=0
end
function c112400020.defvalue(e,c)
	return Duel.GetMatchingGroup(c112400020.deffilter,e:GetHandlerPlayer(),
		LOCATION_EXTRA,0,nil):GetClassCount(Card.GetLevel)*100
end
--e2(search)
function c112400020.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500)
		and Duel.GetCustomActivityCount(112400020,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(112400020,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.PayLPCost(tp,500)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c112400020.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c112400020.thfilter(c)
	return c:IsSetCard(0x4ec1) and not c:IsCode(112400020) and c:IsAbleToHand()
end
function c112400020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112400020.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112400020.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c112400020.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--e3(spsummon)
function c112400020.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(112400020,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(112400020,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c112400020.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c112400020.desfilter(c,e,tp)
	if c:IsFacedown() then return false end
	local b1=c:IsLocation(LOCATION_PZONE) or Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b2=Duel.GetLocationCountFromEx(tp,tp,c,TYPE_PENDULUM)>0
	return Duel.IsExistingMatchingCard(c112400020.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,b1,b2,c)
end
function c112400020.spfilter(c,e,tp,b1,b2,tc)
	return c:GetDefense()==1700 and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and (b1 or (b2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0))
end
function c112400020.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c112400020.desfilter(chkc,e,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c112400020.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c112400020.desfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
end
function c112400020.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
		local b2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(112400020,2))
		local g=Duel.SelectMatchingCard(tp,c112400020.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,b1,b2,nil)
		if #g>0 then
			local sc=g:GetFirst()
			if b1 and (not b2 or not (sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,sc)>0) or Duel.SelectYesNo(tp,aux.Stringid(112400020,3))) then
				Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			else
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

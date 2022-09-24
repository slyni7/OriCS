--ゼリッピ
function c112400002.initial_effect(c)
	--re0(cannot be xyz material)
	local re0=Effect.CreateEffect(c)
	re0:SetType(EFFECT_TYPE_SINGLE)
	re0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	re0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	re0:SetValue(1)
	c:RegisterEffect(re0)
	--pendulum
	if Pendulum then Pendulum.AddProcedure(c) else aux.EnablePendulumAttribute(c) end
	--re1(synchro limit) --2017.5.20 errata
	local re1=Effect.CreateEffect(c)
	re1:SetType(EFFECT_TYPE_SINGLE)
	re1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	re1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	re1:SetValue(c112400002.synlimit)
	c:RegisterEffect(re1)
	--me1(def up)
	local me1=Effect.CreateEffect(c)
	me1:SetType(EFFECT_TYPE_FIELD)
	me1:SetCode(EFFECT_UPDATE_DEFENSE)
	me1:SetRange(LOCATION_MZONE)
	me1:SetTargetRange(LOCATION_ONFIELD,0)
	me1:SetTarget(aux.TargetBoolFunction(c112400002.me1filter))
	me1:SetValue(100)
	c:RegisterEffect(me1)
	--me2(search)
	local me2a=Effect.CreateEffect(c)
	me2a:SetDescription(aux.Stringid(112400002,0))
	me2a:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	me2a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	me2a:SetCode(EVENT_SUMMON_SUCCESS)
	me2a:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	me2a:SetCountLimit(1,112400002)
	me2a:SetTarget(c112400002.me2tg)
	me2a:SetOperation(c112400002.me2op)
	c:RegisterEffect(me2a)
	local me2b=me2a:Clone()
	me2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(me2b)
	--me3(retuning synchro)
	local me3=Effect.CreateEffect(c)
	me3:SetDescription(aux.Stringid(112400002,1))
	me3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	me3:SetType(EFFECT_TYPE_IGNITION)
	me3:SetRange(LOCATION_MZONE)
	me3:SetTarget(c112400002.me3tg)
	me3:SetOperation(c112400002.me3op)
	c:RegisterEffect(me3)
	--pe1(spsummon ed)
	local pe1=Effect.CreateEffect(c)
	pe1:SetDescription(aux.Stringid(112400002,2))
	pe1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	pe1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	pe1:SetCode(EVENT_SPSUMMON_SUCCESS)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetCondition(c112400002.pe1con)
	pe1:SetTarget(c112400002.pe1tg)
	pe1:SetOperation(c112400002.pe1op)
	c:RegisterEffect(pe1)
	--pe2(spsummon self)
	local pe2=Effect.CreateEffect(c)
	pe2:SetDescription(aux.Stringid(112400002,3))
	pe2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	pe2:SetType(EFFECT_TYPE_IGNITION)
	pe2:SetRange(LOCATION_PZONE)
	pe2:SetCountLimit(1,112400001)
	pe2:SetCondition(c112400002.pe2con)
	pe2:SetTarget(c112400002.pe2tg)
	pe2:SetOperation(c112400002.pe2op)
	c:RegisterEffect(pe2)
end
c112400002.listed_series={0x4ec1,0x8ec1}
c112400002.listed_names={112400006}
c112400002.card_code_list={[112400006]=true}
--re1(synchro limit) --2017.5.20 errata
function c112400002.synlimit(e,c)
	return c and not c:IsSetCard(0x4ec1) and not c:IsSetCard(0x8ec1)
end
--me1(defup)
function c112400002.me1filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4ec1)
end
--me2(search)
function c112400002.me2filter(c)
	return c:GetDefense()==1700 and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c112400002.me2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112400002.me2filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112400002.me2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c112400002.me2filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--me3(retuning synchro)
function c112400002.me3filter(c,e,tp)
	return c:IsCode(112400006) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and e:GetHandler():IsCanBeSynchroMaterial(c)
end
function c112400002.me3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112400002.me3filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),TYPE_SYNCHRO)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c112400002.me3op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp,tp,c,TYPE_SYNCHRO)<1 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112400002.me3filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(Group.FromCards(c))
		Duel.SendtoGrave(c,REASON_MATERIAL+REASON_SYNCHRO)
		Duel.BreakEffect()
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
	end
end
--pe1(spsummon ed)
function c112400002.pe1cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c112400002.pe1con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c112400002.pe1cfilter,1,nil,tp)
end
function c112400002.pe1tfilter(c,e,tp)
	return c:IsFaceup() and c:GetDefense()==1700 and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112400002.pe1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112400002.pe1tfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c112400002.pe1op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112400002.pe1tfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--pe2(spsummon self)
function c112400002.pe2cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4ec1)
end
function c112400002.pe2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c112400002.pe2cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c112400002.pe2filter(c)
	return c:IsFaceup() and c:IsSetCard(0x4ec1) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c112400002.pe2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c112400002.pe2filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c112400002.pe2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c112400002.pe2filter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) end
	elseif Duel.GetMZoneCount(tp)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SendtoGrave(c,REASON_RULE)
	end
end

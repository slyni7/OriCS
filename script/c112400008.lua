--フラワーゼリッピ
local s,id=c112400008,112400008
if GetID() then s,id=GetID() end
function s.initial_effect(c)
	--re0(cannot be xyz material)
	local re0=Effect.CreateEffect(c)
	re0:SetType(EFFECT_TYPE_SINGLE)
	re0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	re0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	re0:SetValue(1)
	c:RegisterEffect(re0)
	--synchro summon
	if Synchro then
		Synchro.AddProcedure(c,s.sstfilter,1,1,aux.FilterBoolFunctionEx(Card.IsSetCard,0x4ec1),1,99)
	else
		aux.AddSynchroProcedure(c,s.sstfilter,aux.FilterBoolFunction(Card.IsSetCard,0x4ec1),1)
	end
	c:EnableReviveLimit()
	--pendulum summon
	if Pendulum then Pendulum.AddProcedure(c,false) else aux.EnablePendulumAttribute(c,false) end
	--re1(substitute tuner)
	local re1=Effect.CreateEffect(c)
	re1:SetType(EFFECT_TYPE_SINGLE)
	re1:SetCode(id)
	re1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(re1)
	--re2(synchro limit) --2017.6.15 errata
	local re2=Effect.CreateEffect(c)
	re2:SetType(EFFECT_TYPE_SINGLE)
	re2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	re2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	re2:SetValue(s.synlimit)
	c:RegisterEffect(re2)
	--me1(accel synchro)
	local me1=Effect.CreateEffect(c)
	me1:SetDescription(aux.Stringid(id,0))
	me1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	me1:SetType(EFFECT_TYPE_QUICK_O)
	me1:SetCode(EVENT_FREE_CHAIN)
	me1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	me1:SetRange(LOCATION_MZONE)
	me1:SetCondition(s.sccon)
	me1:SetTarget(s.sctg)
	me1:SetOperation(s.scop)
	c:RegisterEffect(me1)
	--pe1(def up)
	local pe1=Effect.CreateEffect(c)
	pe1:SetType(EFFECT_TYPE_FIELD)
	pe1:SetCode(EFFECT_UPDATE_DEFENSE)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetTargetRange(LOCATION_ONFIELD,0)
	pe1:SetTarget(aux.TargetBoolFunction(s.deffilter))
	pe1:SetValue(s.defvalue)
	c:RegisterEffect(pe1)
	--pe2(dest toh)
	local pe2=Effect.CreateEffect(c)
	pe2:SetDescription(aux.Stringid(id,1))
	pe2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	pe2:SetType(EFFECT_TYPE_IGNITION)
	pe2:SetRange(LOCATION_PZONE)
	pe2:SetCountLimit(1,id)
	--pe2:SetCondition(s.thcon)
	pe2:SetTarget(s.thtg)
	pe2:SetOperation(s.thop)
	c:RegisterEffect(pe2)
end
s.listed_series={0x4ec1,0x8ec1}
s.material_setcode=0x4ec1
--synchro summon
function s.sstfilter(c,sc,sumtype,tp)
	return c:IsSetCard(0x4ec1,sc,sumtype,tp) or c:IsHasEffect(id)
end
--re3(synchro limit) --2017.6.15 errata
function s.synlimit(e,c)
	return c and not c:IsSetCard(0x4ec1) and not c:IsSetCard(0x8ec1)
end
--me1(accel synchro)
function s.sccon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_CHAINING) or Duel.GetTurnPlayer()==tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end
--pe1(def up)
function s.deffilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4ec1)
end
function s.defvalue(e,c)
	return Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_ONFIELD,0):FilterCount(Card.IsType,nil,TYPE_MONSTER)*200
end
--pe2(dest toh)
function s.thfilter(c,code1,code2)
	return c:IsFaceup() and c:IsSetCard(0x4ec1) and bit.band(c:GetType(),0x1000001)==0x1000001
		and c:IsAbleToHand() and not c:IsCode(code1,code2)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local pc=Duel.GetFirstMatchingCard(aux.TRUE,tp,LOCATION_PZONE,0,c)
	if chk==0 then return pc and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_EXTRA,0,2,nil,c:GetCode(),pc:GetCode()) end
	local g=Group.FromCards(c,pc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_EXTRA)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pc=Duel.GetFirstMatchingCard(aux.TRUE,tp,LOCATION_PZONE,0,c)
	if not pc then return end
	local dg=Group.FromCards(c,pc)
	if Duel.Destroy(dg,REASON_EFFECT)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_EXTRA,0,2,2,nil,c:GetCode(),pc:GetCode())
	if #g==2 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--ポイズンゼリッピ
function c112400007.initial_effect(c)
	--re0(cannot be xyz material)
	local re0=Effect.CreateEffect(c)
	re0:SetType(EFFECT_TYPE_SINGLE)
	re0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	re0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	re0:SetValue(1)
	c:RegisterEffect(re0)
	--synchro summon
	if Synchro then
		Synchro.AddProcedure(c,c112400007.sstfilter,1,1,Synchro.NonTuner(Card.IsSetCard,0x4ec1),1,1)
	else
		aux.AddSynchroProcedure2(c,c112400007.sstfilter,aux.NonTuner(Card.IsSetCard,0x4ec1))
	end
	c:EnableReviveLimit()
	--pendulum summon
	if Pendulum then Pendulum.AddProcedure(c,false) else aux.EnablePendulumAttribute(c,false) end
	--re1(synchro limit) --2017.6.15 errata
	local re1=Effect.CreateEffect(c)
	re1:SetType(EFFECT_TYPE_SINGLE)
	re1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	re1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	re1:SetValue(c112400007.synlimit)
	c:RegisterEffect(re1)
	--me1(def up)
	local me1=Effect.CreateEffect(c)
	me1:SetType(EFFECT_TYPE_FIELD)
	me1:SetCode(EFFECT_UPDATE_DEFENSE)
	me1:SetRange(LOCATION_MZONE)
	me1:SetTargetRange(LOCATION_ONFIELD,0)
	me1:SetTarget(aux.TargetBoolFunction(c112400007.me1filter))
	me1:SetValue(300)
	c:RegisterEffect(me1)
	--me2(banish)
	local me2=Effect.CreateEffect(c)
	me2:SetDescription(aux.Stringid(112400007,0))
	me2:SetCategory(CATEGORY_REMOVE)
	me2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	me2:SetCode(EVENT_SPSUMMON_SUCCESS)
	me2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	me2:SetCondition(c112400007.me2con)
	me2:SetTarget(c112400007.me2tg)
	me2:SetOperation(c112400007.me2op)
	c:RegisterEffect(me2)
	--me3(retuning synchro)
	local me3=Effect.CreateEffect(c)
	me3:SetDescription(aux.Stringid(112400007,1))
	me3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	me3:SetType(EFFECT_TYPE_IGNITION)
	me3:SetRange(LOCATION_MZONE)
	me3:SetTarget(c112400007.me3tg)
	me3:SetOperation(c112400007.me3op)
	c:RegisterEffect(me3)
	--pe1(spsummon ed)
	local pe1=Effect.CreateEffect(c)
	pe1:SetDescription(aux.Stringid(112400007,2))
	pe1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	pe1:SetType(EFFECT_TYPE_IGNITION)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetCountLimit(1)
	pe1:SetTarget(c112400007.pe1tg)
	pe1:SetOperation(c112400007.pe1op)
	c:RegisterEffect(pe1)
	--pe2(pendulum set)
	local pe2=Effect.CreateEffect(c)
	pe2:SetDescription(aux.Stringid(112400007,3))
	pe2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	pe2:SetType(EFFECT_TYPE_IGNITION)
	pe2:SetRange(LOCATION_PZONE)
	pe2:SetCountLimit(1) --2017.1.15 errata
	pe2:SetTarget(c112400007.pe2tg)
	pe2:SetOperation(c112400007.pe2op)
	c:RegisterEffect(pe2)
end
c112400007.listed_series={0x4ec1,0x8ec1}
c112400007.listed_names={112400002,112400009}
c112400007.card_code_list={[112400002]=true,[112400009]=true}
c112400007.material_setcode=0x4ec1
--synchro summon
function c112400007.sstfilter(c,sc,sumtype,tp)
	return c:IsSetCard(0x4ec1,sc,sumtype,tp) or c:IsHasEffect(112400008)
end
--re1(synchro limit) --2017.6.15 errata
function c112400007.synlimit(e,c)
	return c and not c:IsSetCard(0x4ec1) and not c:IsSetCard(0x8ec1)
end
--me1(def up)
function c112400007.me1filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4ec1)
end
--me2(banish)
function c112400007.me2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c112400007.me2filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c112400007.me2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c112400007.me2filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c112400007.me2filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c112400007.me2filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c112400007.me2op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
--me3(retuning synchro)
function c112400007.me3filter(c,e,tp)
	return c:IsCode(112400009) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and e:GetHandler():IsCanBeSynchroMaterial(c)
end
function c112400007.me3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112400007.me3filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),TYPE_SYNCHRO)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c112400007.me3op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp,tp,c,TYPE_SYNCHRO)<1 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112400007.me3filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
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
--pe1(spsummon "Jellypi")
function c112400007.pe1tfilter(c,e,tp)
	return c:IsCode(112400002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c112400007.pe1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112400007.pe1tfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c112400007.pe1op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112400007.pe1tfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--pe2(pendulum set)
function c112400007.pe2pzfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x4ec1) and c:IsLocation(LOCATION_PZONE)
end
function c112400007.pe2edfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4ec1) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c112400007.pe2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c112400007.pe2pzfilter(chkc,e) end
	if chk==0 then return Duel.IsExistingMatchingCard(c112400007.pe2edfilter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsExistingTarget(c112400007.pe2pzfilter,tp,LOCATION_ONFIELD,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c112400007.pe2pzfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c112400007.pe2op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c112400007.pe2edfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local sc=g:GetFirst()
		if sc then
			Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetTarget(aux.TargetEqualFunction(Card.IsLocation,LOCATION_PZONE))
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		Duel.RegisterEffect(e2,tp)
	end
end

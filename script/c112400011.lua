--アイスゼリッピ
if not MASTER_RULE_3 then MASTER_RULE_3=not Duel.GetUsableMZoneCount end
function c112400011.initial_effect(c)
	--re0(cannot be xyz material)
	local re0=Effect.CreateEffect(c)
	re0:SetType(EFFECT_TYPE_SINGLE)
	re0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	re0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	re0:SetValue(1)
	c:RegisterEffect(re0)
	--synchro summon
	if Synchro then
		Synchro.AddProcedure(c,c112400011.sstfilter,1,1,Synchro.NonTuner(Card.IsSetCard,0x4ec1),1,1)
	else
		aux.AddSynchroProcedure2(c,c112400011.sstfilter,aux.NonTuner(Card.IsSetCard,0x4ec1))
	end
	c:EnableReviveLimit()
	--pendulum summon
	if Pendulum then Pendulum.AddProcedure(c,false) else aux.EnablePendulumAttribute(c,false) end
	--re1(synchro limit) --2017.6.15 errata
	local re1=Effect.CreateEffect(c)
	re1:SetType(EFFECT_TYPE_SINGLE)
	re1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	re1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	re1:SetValue(c112400011.synlimit)
	c:RegisterEffect(re1)
	--me1(def up)
	local me1=Effect.CreateEffect(c)
	me1:SetType(EFFECT_TYPE_FIELD)
	me1:SetCode(EFFECT_UPDATE_DEFENSE)
	me1:SetRange(LOCATION_MZONE)
	me1:SetTargetRange(LOCATION_ONFIELD,0)
	me1:SetTarget(aux.TargetBoolFunction(c112400011.me1filter))
	me1:SetValue(500)
	c:RegisterEffect(me1)
	--me2(banish)
	local me2=Effect.CreateEffect(c)
	me2:SetDescription(aux.Stringid(112400011,0))
	me2:SetCategory(CATEGORY_REMOVE)
	me2:SetType(EFFECT_TYPE_IGNITION)
	me2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	me2:SetRange(LOCATION_MZONE)
	me2:SetCountLimit(1)
	me2:SetTarget(c112400011.me2tg)
	me2:SetOperation(c112400011.me2op)
	c:RegisterEffect(me2)
	--valcheck
	local ve1=Effect.CreateEffect(c)
	ve1:SetType(EFFECT_TYPE_SINGLE)
	ve1:SetCode(EFFECT_MATERIAL_CHECK)
	ve1:SetValue(c112400011.valcheck)
	ve1:SetLabelObject(me2)
	c:RegisterEffect(ve1)
	--pe1(spsummon ed)
	local pe1=Effect.CreateEffect(c)
	pe1:SetDescription(aux.Stringid(112400011,2))
	pe1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	pe1:SetType(EFFECT_TYPE_IGNITION)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetCountLimit(1)
	pe1:SetTarget(c112400011.pe1tg)
	pe1:SetOperation(c112400011.pe1op)
	c:RegisterEffect(pe1)
	--pe2(pendulum set)
	local pe2=Effect.CreateEffect(c)
	pe2:SetDescription(aux.Stringid(112400011,3))
	pe2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	pe2:SetType(EFFECT_TYPE_IGNITION)
	pe2:SetRange(LOCATION_PZONE)
	pe2:SetCountLimit(1) --2017.1.15 errata
	pe2:SetTarget(c112400011.pe2tg)
	pe2:SetOperation(c112400011.pe2op)
	c:RegisterEffect(pe2)
end
c112400011.listed_series={0x4ec1,0x8ec1}
c112400011.listed_names={112400002,112400010}
c112400011.card_code_list={[112400002]=true,[112400010]=true}
c112400011.material_setcode=0x4ec1
--synchro summon
function c112400011.sstfilter(c,sc,sumtype,tp)
	return c:IsSetCard(0x4ec1,sc,sumtype,tp) or c:IsHasEffect(112400008)
end
--re1(synchro limit) --2017.6.15 errata
function c112400011.synlimit(e,c)
	return c and not c:IsSetCard(0x4ec1) and not c:IsSetCard(0x8ec1)
end
--me1(def up)
function c112400011.me1filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4ec1)
end
--me2(banish)
function c112400011.me2tfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c112400011.me2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c112400011.me2tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c112400011.me2tfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c112400011.me2tfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c112400011.me2ofilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c112400011.me2op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0 and e:GetLabel()==1
		and Duel.IsExistingMatchingCard(c112400011.me2ofilter,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(112400011,11)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c112400011.valfilter(c,sc,tp)
	if Card.IsSummonCode then --EDOPro
		return c:IsSummonCode(sc,SUMMON_TYPE_SYNCHRO,tp,112400010)
	elseif Card.IsSynchroCode then --Core?
		return c:IsSynchroCode(112400010)
	else
		return c:IsCode(112400010)
	end
end
function c112400011.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c112400011.valfilter,1,nil,c,c:GetSummonPlayer()) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
--pe1(spsummon "Jellypi")
function c112400011.pe1tfilter(c,e,tp)
	return c:IsCode(112400002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c112400011.pe1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112400011.pe1tfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c112400011.pe1op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112400011.pe1tfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--pe2(pendulum set)
function c112400011.pe2pzfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x4ec1) and c:IsLocation(LOCATION_PZONE)
end
function c112400011.pe2edfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4ec1) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c112400011.pe2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c112400011.pe2pzfilter(chkc,e) end
	if chk==0 then return Duel.IsExistingMatchingCard(c112400011.pe2edfilter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsExistingTarget(c112400011.pe2pzfilter,tp,LOCATION_ONFIELD,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c112400011.pe2pzfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c112400011.pe2op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c112400011.pe2edfilter,tp,LOCATION_EXTRA,0,1,1,nil)
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

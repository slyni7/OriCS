--ホットゼリッピ
function c112400012.initial_effect(c)
	--re0(cannot be xyz material)
	local re0=Effect.CreateEffect(c)
	re0:SetType(EFFECT_TYPE_SINGLE)
	re0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	re0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	re0:SetValue(1)
	c:RegisterEffect(re0)
	--synchro summon
	if aux.AddSynchroMixProcedure then --Koishi or Core
		aux.AddSynchroMixProcedure(c,c112400012.mfilter1,c112400012.mfilter2,c112400012.mfilter3,c112400012.mfilter4,1,1,c112400012.gfilter)
	else --EDOPro
		Synchro.AddProcedure(c,nil,1,1,nil,3,3,c112400012.mfilter1,nil,nil,c112400012.mfilters,c112400012.gfilter)
	end
	c:EnableReviveLimit()
	--pendulum summon
	if Pendulum then Pendulum.AddProcedure(c,false) else aux.EnablePendulumAttribute(c,false) end
	--spsummon condition
	local sce=Effect.CreateEffect(c)
	sce:SetType(EFFECT_TYPE_SINGLE)
	sce:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	sce:SetCode(EFFECT_SPSUMMON_CONDITION)
	sce:SetValue(c112400012.splimit)
	c:RegisterEffect(sce)
	--me1(def up)
	local me1=Effect.CreateEffect(c)
	me1:SetType(EFFECT_TYPE_FIELD)
	me1:SetCode(EFFECT_UPDATE_DEFENSE)
	me1:SetRange(LOCATION_MZONE)
	me1:SetTargetRange(LOCATION_ONFIELD,0)
	me1:SetTarget(aux.TargetBoolFunction(c112400012.me1filter))
	me1:SetValue(900)
	c:RegisterEffect(me1)
	--me2(destroy)
	local me2=Effect.CreateEffect(c)
	me2:SetDescription(aux.Stringid(112400012,0))
	me2:SetCategory(CATEGORY_REMOVE)
	me2:SetType(EFFECT_TYPE_IGNITION)
	me2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	me2:SetRange(LOCATION_MZONE)
	me2:SetCountLimit(1)
	me2:SetTarget(c112400012.me2tg)
	me2:SetOperation(c112400012.me2op)
	c:RegisterEffect(me2)
	--pe1(spsummon ed)
	local pe1=Effect.CreateEffect(c)
	pe1:SetDescription(aux.Stringid(112400012,2))
	pe1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	pe1:SetType(EFFECT_TYPE_IGNITION)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetCountLimit(1)
	pe1:SetTarget(c112400012.pe1tg)
	pe1:SetOperation(c112400012.pe1op)
	c:RegisterEffect(pe1)
	--pe2(pendulum set)
	local pe2=Effect.CreateEffect(c)
	pe2:SetDescription(aux.Stringid(112400012,3))
	pe2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	pe2:SetType(EFFECT_TYPE_IGNITION)
	pe2:SetRange(LOCATION_PZONE)
	pe2:SetCountLimit(1) --2017.1.15 errata
	pe2:SetTarget(c112400012.pe2tg)
	pe2:SetOperation(c112400012.pe2op)
	c:RegisterEffect(pe2)
end
c112400012.listed_series={0x4ec1}
c112400012.listed_names={112400002,112400006,112400007,112400009}
c112400012.card_code_list={[112400002]=true,[112400006]=true,[112400007]=true,[112400009]=true}
c112400012.material_setcode=0x4ec1
--synchro summon (Koishi)
function c112400012.mfilter1(c)
	return (c:IsCode(112400002) or c:IsHasEffect(112400008))
end
function c112400012.mfilter2(c)
	return (c:IsCode(112400006) or c:IsHasEffect(112400008))
end
function c112400012.mfilter3(c)
	return (c:IsCode(112400007) or c:IsHasEffect(112400008))
end
function c112400012.mfilter4(c)
	return (c:IsCode(112400009) or c:IsHasEffect(112400008))
end
function c112400012.gfilter(g)
	return g:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end
--synchro summon (EDOPro)
function c112400012.materialCheck(c,mg,sg,sc,tp,f1,f2,...)
	if f2 then
		sg:AddCard(c)
		local res=false
		if f1(c,sc,SUMMON_TYPE_SYNCHRO,tp) then
			res=mg:IsExists(c112400012.materialCheck,1,sg,mg,sg,sc,tp,f2,...)
		end
		sg:RemoveCard(c)
		return res
	else
		sg:AddCard(c)
		local res=false
		if f1(c,sc,SUMMON_TYPE_SYNCHRO,tp) then
			res=#mg==#sg or mg:IsExists(c112400012.materialCheck,1,sg,mg,sg,sc,tp,f1)
		end
		sg:RemoveCard(c)
		return res
	end
end
function c112400012.mfilters(g,sc,tp)
	local sg=Group.CreateGroup()
	return g:IsExists(c112400012.materialCheck,1,nil,g,sg,sc,tp,c112400012.mfilter2,c112400012.mfilter3,c112400012.mfilter4)
end
--spsummon condition
function c112400012.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO or bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
--me1(def up)
function c112400012.me1filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4ec1)
end
--me2(destroy)
function c112400012.me2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c112400012.me2op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if #g>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		if ct>0 then Duel.Damage(1-tp,ct*300,REASON_EFFECT) end
	end
end
--pe1(spsummon "Jellypi")
function c112400012.pe1tfilter(c,e,tp)
	return c:IsCode(112400002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c112400012.pe1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112400012.pe1tfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c112400012.pe1op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112400012.pe1tfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--pe2(pendulum set)
function c112400012.pe2pzfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x4ec1) and c:IsLocation(LOCATION_PZONE)
end
function c112400012.pe2edfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4ec1) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c112400012.pe2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c112400012.pe2pzfilter(chkc,e) end
	if chk==0 then return Duel.IsExistingMatchingCard(c112400012.pe2edfilter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsExistingTarget(c112400012.pe2pzfilter,tp,LOCATION_ONFIELD,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c112400012.pe2pzfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c112400012.pe2op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c112400012.pe2edfilter,tp,LOCATION_EXTRA,0,1,1,nil)
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

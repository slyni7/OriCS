--ホットゼリッピ
local s,id=c112400012,112400012
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
	if aux.AddSynchroMixProcedure then --Koishi or Core
		aux.AddSynchroMixProcedure(c,s.mfilter1,s.mfilter2,s.mfilter3,s.mfilter4,1,1,s.gfilter)
	else --EDOPro
		Synchro.AddProcedure(c,nil,1,1,nil,3,3,s.mfilter1,nil,nil,s.mfilters,s.gfilter)
	end
	c:EnableReviveLimit()
	--pendulum summon
	if Pendulum then Pendulum.AddProcedure(c,false) else aux.EnablePendulumAttribute(c,false) end
	--spsummon condition
	local sce=Effect.CreateEffect(c)
	sce:SetType(EFFECT_TYPE_SINGLE)
	sce:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	sce:SetCode(EFFECT_SPSUMMON_CONDITION)
	sce:SetValue(s.splimit)
	c:RegisterEffect(sce)
	--me1(def up)
	local me1=Effect.CreateEffect(c)
	me1:SetType(EFFECT_TYPE_FIELD)
	me1:SetCode(EFFECT_UPDATE_DEFENSE)
	me1:SetRange(LOCATION_MZONE)
	me1:SetTargetRange(LOCATION_ONFIELD,0)
	me1:SetTarget(aux.TargetBoolFunction(s.me1filter))
	me1:SetValue(900)
	c:RegisterEffect(me1)
	--me2(destroy)
	local me2=Effect.CreateEffect(c)
	me2:SetDescription(aux.Stringid(id,0))
	me2:SetCategory(CATEGORY_REMOVE)
	me2:SetType(EFFECT_TYPE_IGNITION)
	me2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	me2:SetRange(LOCATION_MZONE)
	me2:SetCountLimit(1)
	me2:SetTarget(s.me2tg)
	me2:SetOperation(s.me2op)
	c:RegisterEffect(me2)
	--pe1(spsummon ed)
	local pe1=Effect.CreateEffect(c)
	pe1:SetDescription(aux.Stringid(id,2))
	pe1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	pe1:SetType(EFFECT_TYPE_IGNITION)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetCountLimit(1)
	pe1:SetTarget(s.pe1tg)
	pe1:SetOperation(s.pe1op)
	c:RegisterEffect(pe1)
	--pe2(pendulum set)
	local pe2=Effect.CreateEffect(c)
	pe2:SetDescription(aux.Stringid(id,3))
	pe2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	pe2:SetType(EFFECT_TYPE_IGNITION)
	pe2:SetRange(LOCATION_PZONE)
	pe2:SetCountLimit(1) --2017.1.15 errata
	pe2:SetTarget(s.pe2tg)
	pe2:SetOperation(s.pe2op)
	c:RegisterEffect(pe2)
end
s.listed_series={0x4ec1}
s.listed_names={112400002,112400006,112400007,112400009}
s.card_code_list={[112400002]=true,[112400006]=true,[112400007]=true,[112400009]=true}
s.material_setcode=0x4ec1
--synchro summon (Koishi)
function s.mfilter1(c)
	return (c:IsCode(112400002) or c:IsHasEffect(112400008))
end
function s.mfilter2(c)
	return (c:IsCode(112400006) or c:IsHasEffect(112400008))
end
function s.mfilter3(c)
	return (c:IsCode(112400007) or c:IsHasEffect(112400008))
end
function s.mfilter4(c)
	return (c:IsCode(112400009) or c:IsHasEffect(112400008))
end
function s.gfilter(g)
	return g:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end
--synchro summon (EDOPro)
function s.materialCheck(c,mg,sg,sc,tp,f1,f2,...)
	if f2 then
		sg:AddCard(c)
		local res=false
		if f1(c,sc,SUMMON_TYPE_SYNCHRO,tp) then
			res=mg:IsExists(s.materialCheck,1,sg,mg,sg,sc,tp,f2,...)
		end
		sg:RemoveCard(c)
		return res
	else
		sg:AddCard(c)
		local res=false
		if f1(c,sc,SUMMON_TYPE_SYNCHRO,tp) then
			res=#mg==#sg or mg:IsExists(s.materialCheck,1,sg,mg,sg,sc,tp,f1)
		end
		sg:RemoveCard(c)
		return res
	end
end
function s.mfilters(g,sc,tp)
	local sg=Group.CreateGroup()
	return g:IsExists(s.materialCheck,1,nil,g,sg,sc,tp,s.mfilter2,s.mfilter3,s.mfilter4)
end
--spsummon condition
function s.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO or bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
--me1(def up)
function s.me1filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4ec1)
end
--me2(destroy)
function s.me2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.me2op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if #g>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		if ct>0 then Duel.Damage(1-tp,ct*300,REASON_EFFECT) end
	end
end
--pe1(spsummon "Jellypi")
function s.pe1tfilter(c,e,tp)
	return c:IsCode(112400002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.pe1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.pe1tfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.pe1op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.pe1tfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--pe2(pendulum set)
function s.pe2pzfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x4ec1) and c:IsLocation(LOCATION_PZONE)
end
function s.pe2edfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4ec1) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.pe2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and s.pe2pzfilter(chkc,e) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.pe2edfilter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsExistingTarget(s.pe2pzfilter,tp,LOCATION_ONFIELD,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.pe2pzfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.pe2op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,s.pe2edfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local sc=g:GetFirst()
		if sc then
			Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_PZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(aux.TRUE))
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

--ゼリッピリ
local s,id=c112400001,112400001
if GetID() then s,id=GetID() end
function s.initial_effect(c)
	--pendulum
	if Pendulum then Pendulum.AddProcedure(c) else aux.EnablePendulumAttribute(c) end
	--pe1(splimit)
	local pe1=Effect.CreateEffect(c)
	pe1:SetType(EFFECT_TYPE_FIELD)
	pe1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	pe1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetTargetRange(1,0)
	pe1:SetTarget(s.splimit)
	c:RegisterEffect(pe1)
	--pe2(pscale)
	local pe2a=Effect.CreateEffect(c)
	pe2a:SetType(EFFECT_TYPE_SINGLE)
	pe2a:SetCode(EFFECT_UPDATE_LSCALE)
	pe2a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	pe2a:SetRange(LOCATION_PZONE)
	pe2a:SetValue(s.psvalue)
	c:RegisterEffect(pe2a)
	local pe2b=pe2a:Clone()
	pe2b:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(pe2b)
end
s.listed_series={0x4ec1,0x8ec1}
--pe1(splimit)
function s.spfilter(c)
	return c:IsSetCard(0x4ec1) or c:IsSetCard(0x8ec1)
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return not s.spfilter(c)
		and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
--pe2(pscale)
function s.psfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4ec1)
end
function s.psvalue(e,c)
	return Duel.GetMatchingGroupCount(s.psfilter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,nil)
end
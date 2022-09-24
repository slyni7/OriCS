--ゼリッピリ
function c112400001.initial_effect(c)
	--ゼリッピ(112400002) has e:SetCountLimit(1,112400001)
	--pendulum
	if Pendulum then Pendulum.AddProcedure(c) else aux.EnablePendulumAttribute(c) end
	--pe1(splimit)
	local pe1=Effect.CreateEffect(c)
	pe1:SetType(EFFECT_TYPE_FIELD)
	pe1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	pe1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetTargetRange(1,0)
	pe1:SetTarget(c112400001.splimit)
	c:RegisterEffect(pe1)
	--pe2(pscale)
	local pe2a=Effect.CreateEffect(c)
	pe2a:SetType(EFFECT_TYPE_SINGLE)
	pe2a:SetCode(EFFECT_UPDATE_LSCALE)
	pe2a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	pe2a:SetRange(LOCATION_PZONE)
	pe2a:SetValue(c112400001.psvalue)
	c:RegisterEffect(pe2a)
	local pe2b=pe2a:Clone()
	pe2b:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(pe2b)
end
c112400001.listed_series={0x4ec1,0x8ec1}
--pe1(splimit)
function c112400001.spfilter(c)
	return c:IsSetCard(0x4ec1) or c:IsSetCard(0x8ec1)
end
function c112400001.splimit(e,c,tp,sumtp,sumpos)
	return not c112400001.spfilter(c)
		and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
--pe2(pscale)
function c112400001.psfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4ec1)
end
function c112400001.psvalue(e,c)
	return Duel.GetMatchingGroupCount(c112400001.psfilter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,nil)
end
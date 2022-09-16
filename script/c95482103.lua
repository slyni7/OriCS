--알피스트 레굴루스
function c95482103.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,95482101,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),1,true,true)
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c95482103.aclimit1)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c95482103.econ1)
	e3:SetValue(c95482103.elimit)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetOperation(c95482103.aclimit3)
	c:RegisterEffect(e4)
	local e6=e3:Clone()
	e6:SetCondition(c95482103.econ2)
	e6:SetTargetRange(0,1)
	c:RegisterEffect(e6)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c95482103.splimit)
	c:RegisterEffect(e0)
end
function c95482103.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsSetCard(0xd5a)
end

function c95482103.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(95482103,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c95482103.econ1(e)
	return e:GetHandler():GetFlagEffect(95482103)~=0 and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c95482103.aclimit3(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(95482197,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c95482103.econ2(e)
	return e:GetHandler():GetFlagEffect(95482197)~=0 and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c95482103.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e) 
	and bit.band(re:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL 
	and bit.band(re:GetHandler():GetSummonLocation(),LOCATION_EXTRA)==LOCATION_EXTRA
end
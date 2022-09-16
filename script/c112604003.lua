--심야의 마녀(아트릭시아) 나이트코드
local m=112604003
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
	--Attribute
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_ONFIELD)
	e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e0:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e0:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
end

cm.CardType_ExRitual=true

--immune
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
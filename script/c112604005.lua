--망상의 마녀(아트릭시아) 지니
local m=112604005
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
end

cm.CardType_ExRitual=true
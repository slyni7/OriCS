--사일런트 머조리티: 6
local m=18453080
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
cm.square_mana={ATTRIBUTE_EARTH,ATTRIBUTE_EARTH}
cm.custom_type=CUSTOMTYPE_SQUARE
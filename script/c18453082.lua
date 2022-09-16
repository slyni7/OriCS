--사일런트 머조리티: 8
local m=18453082
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
end
cm.square_mana={ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT}
cm.custom_type=CUSTOMTYPE_SQUARE
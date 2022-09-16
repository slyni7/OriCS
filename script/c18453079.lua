--사일런트 머조리티: 5
local m=18453079
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
end
cm.square_mana={ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT}
cm.custom_type=CUSTOMTYPE_SQUARE
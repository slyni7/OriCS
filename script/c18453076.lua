--사일런트 머조리티: 2
local m=18453076
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
end
cm.square_mana={ATTRIBUTE_FIRE}
cm.custom_type=CUSTOMTYPE_SQUARE
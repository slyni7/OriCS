--사일런트 머조리티: 3
local m=18453077
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
end
cm.square_mana={ATTRIBUTE_EARTH}
cm.custom_type=CUSTOMTYPE_SQUARE
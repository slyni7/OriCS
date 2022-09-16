--사일런트 머조리티: 1
local m=18453075
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
end
cm.square_mana={ATTRIBUTE_WIND}
cm.custom_type=CUSTOMTYPE_SQUARE
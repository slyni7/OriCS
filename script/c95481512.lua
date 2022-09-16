--계승천사 파타
function c95481512.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_LIGHT),1,1,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
end

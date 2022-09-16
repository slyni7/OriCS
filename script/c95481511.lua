--계승천사 카마츠 카탄
function c95481511.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_LIGHT),1,1,aux.NonTuner(nil),2,99)
	c:EnableReviveLimit()
end

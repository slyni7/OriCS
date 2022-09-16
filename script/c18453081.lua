--사일런트 머조리티: 7
local m=18453081
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"F","G")
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetTR("HM",0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2e0))
	c:RegisterEffect(e1)
end
cm.square_mana={ATTRIBUTE_DARK,ATTRIBUTE_DARK,ATTRIBUTE_DARK}
cm.custom_type=CUSTOMTYPE_SQUARE
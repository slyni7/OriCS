--C1tYPop(나이트 스케이프) ¤ 레크
local m=112604102
local cm=_G["c"..m]
function cm.initial_effect(c)
	--spsummon
	kaos.C1tYPop(c)
	--to grave
	kaos.UNEVER(c)
	--cannot target/indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(cm.immtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
end

--cannot target/indes
function cm.immtg(e,c)
	return c:IsSetCard(0xe72) and c:IsType(TYPE_MONSTER)
end
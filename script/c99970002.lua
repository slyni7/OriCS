--[ Module 2 ]
local m=99970002
local cm=_G["c"..m]
function cm.initial_effect(c)

	--모듈 소환
	RevLim(c)
	aux.AddModuleProcedure(c,aux.FBF(Card.IsModuleAttribute,ATTRIBUTE_WATER),cm.mod2,1,1,nil)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	
	--직접 공격
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(cm.dircon)
	c:RegisterEffect(e2)
	
end

--모듈 소환
function cm.mod2(c)
	return c:IsType(TYPE_TRAP) or c:IsOriginalType(TYPE_MONSTER)
end

--몬스터 / 함정 내성
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_EFFECT+TYPE_TRAP)
end

--직접 공격
function cm.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.dircon(e)
	return Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,3,nil)
end

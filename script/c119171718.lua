--백발의 노인
local s,id=GetID()
function s.initial_effect(c)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_CODE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetValue(id)
	c:RegisterEffect(e5)
end

function s.efilter(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER) and
		((re:IsHasType(EFFECT_TYPE_ACTIONS) and re:GetActivateLocation()==LOCATION_MZONE)
			or (not re:IsHasType(EFFECT_TYPE_ACTIONS) and re:GetHandler():IsLocation(LOCATION_MZONE)))
end

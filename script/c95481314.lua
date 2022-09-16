--여명을 밝히는 용 LV10
function c95481314.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64880894,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c95481314.drtg)
	e2:SetOperation(c95481314.drop)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c95481314.chainop)
	c:RegisterEffect(e3)
	--cannot disable summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e5)
end

c95481314.lvupcount=1
c95481314.lvup={95481313}
c95481314.lvdncount=3
c95481314.lvdn={95481313,95481312,95481311}

function c95481314.filter(c,def)
	return c:IsFaceup() and (c:GetDefense()<=def or c:GetAttack<=def)
end
function c95481314.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c95481314.filter,tp,0,LOCATION_MZONE,c,c:GetDefense())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c95481314.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c95481314.filter,tp,0,LOCATION_MZONE,c,c:GetDefense())
	Duel.Destroy(g,REASON_EFFECT)
end


function c95481314.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_ACTIVATE) then
		Duel.SetChainLimit(c95481314.chainlm)
	end
end
function c95481314.chainlm(e,rp,tp)
	return tp==rp
end


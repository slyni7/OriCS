--천명신 데셉티오
function c95480304.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c95480304.target)
	e1:SetOperation(c95480304.activate)
	c:RegisterEffect(e1)
	--monster effects
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35394356,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,95480304)
	e2:SetCondition(c95480304.rcon)
	e2:SetOperation(c95480304.rop)
	c:RegisterEffect(e2)
end
function c95480304.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,95480304,0,0x21,1600,1900,6,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c95480304.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,95480304,0,0x21,1600,1900,6,RACE_FIEND,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,1,tp,tp,true,false,POS_FACEUP)
end
function c95480304.rcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ)
		and re:GetHandler():GetOverlayCount()>=ev-1 and re:GetHandler():IsSetCard(0x1d41) and e:GetHandler():IsAbleToRemoveAsCost() and ep==e:GetOwnerPlayer()
end
function c95480304.rop(e,tp,eg,ep,ev,re,r,rp)
	return Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
--MMJ : Kagemusha
function c81010170.initial_effect(c)
	
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010170,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xca1))
	c:RegisterEffect(e2)
	
	--summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c81010170.pslimit)
	c:RegisterEffect(e3)

	--revive
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81010170,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,81010170)
	e4:SetCost(c81010170.rvco)
	e4:SetTarget(c81010170.rvtg1)
	e4:SetOperation(c81010170.rvop1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetRange(LOCATION_EXTRA)
	e5:SetTarget(c81010170.rvtg2)
	e5:SetOperation(c81010170.rvop2)
	c:RegisterEffect(e5)
	
end

--pendulum summon limit
function c81010170.pslimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0xca1) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

--revive
function c81010170.rvcofilter(c)
	return c:IsSetCard(0xca1) and c:IsFaceup() and c:IsAbleToRemoveAsCost() and not c:IsCode(81010170)
end
function c81010170.rvco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010170.rvcofilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81010170.rvcofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

--Grave
function c81010170.rvtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81010170.rvop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--Extra
function c81010170.rvtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81010170.rvop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

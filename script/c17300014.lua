--
function c17300014.initial_effect(c)
	aux.AddCodeList(c,17300003)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17300014+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c17300014.target)
	e1:SetOperation(c17300014.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,17299986)
	e2:SetCost(c17300014.thcost)
	e2:SetTarget(c17300014.thtg)
	e2:SetOperation(c17300014.thop)
	c:RegisterEffect(e2)
end
function c17300014.filter(c,e,tp,m,ft)
	if not c:IsCode(17300003)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) then return false end
	local mg=m:Clone()
	return mg:IsExists(c17300014.mfilterf,1,c,tp,m,ft,c)
end
function c17300014.mfilterf(c,tp,mg,ft,rc)
	if (c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5)
		or ft>0 then
		local mlv=c:GetRitualLevel(rc)
		local lv=rc:GetLevel()
		return lv<=bit.band(mlv,0xffff) or lv<=bit.rshift(mlv,16)
	end
	return false
end
function c17300014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_PZONE,0,nil,0x2d1)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c17300014.filter,tp,LOCATION_PZONE,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function c17300014.activate(e,tp,eg,ep,ev,re,r,rp)
		local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_PZONE,0,nil,0x2d1)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c17300014.filter,tp,LOCATION_PZONE,0,1,1,nil,e,tp,mg,ft)
	local tc=tg:GetFirst()
	if tc then
		local mat=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		mat=mg:FilterSelect(tp,c17300014.mfilterf,1,1,tc,tp,mg,ft,tc)
		Duel.SetSelectedCard(mat)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

function c17300014.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c17300014.thfilter(c)
	return c:IsSetCard(0x2d1) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))
end
function c17300014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17300014.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c17300014.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17300014.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

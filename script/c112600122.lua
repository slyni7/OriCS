--欺界裝置 設計神(데우스 마키나)
function c112600122.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c112600122.spcon)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112600122,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c112600122.spcost)
	e2:SetTarget(c112600122.sptg)
	e2:SetOperation(c112600122.spop)
	c:RegisterEffect(e2)
end
function c112600122.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe89) and c:IsType(TYPE_TOKEN)
end
function c112600122.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c112600122.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c112600122.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c112600122.spfilter(c,e,tp)
	return c:IsSetCard(0xe89) and c:IsType(TYPE_MONSTER) and not c:IsCode(112600122) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112600122.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c112600122.spfilter,tp,LOCATION_DECK or LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK or LOCATION_GRAVE)
end
function c112600122.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112600122.spfilter,tp,LOCATION_DECK or LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then 
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c112600122.filter(c)
	return c:IsSetCard(0xe89) and c:IsType(TYPE_MONSTER) and not c:IsCode(112600122) and c:IsAbleToHand()
end
function c112600122.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(1,CATEGORY_DRAW,nil,0,tp,1)
end
function c112600122.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
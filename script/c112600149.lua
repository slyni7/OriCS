--欺界裝置最高神(데우스 엑스 마키나)
function c112600149.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xe89),2,2,c112600149.lcheck)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c112600149.splimit)
	c:RegisterEffect(e0)
	--lindes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCondition(c112600149.indescon)
	e1:SetTarget(c112600149.indestg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112600149,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c112600149.sptg)
	e3:SetOperation(c112600149.spop)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(c112600149.indcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	--activate limit
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(112600149,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c112600149.cost)
	e6:SetOperation(c112600149.operation)
	c:RegisterEffect(e6)
	--disable
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(112600149,2))
	e7:SetCategory(CATEGORY_TODECK+CATEGORY_DISABLE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c112600149.discon)
	e7:SetTarget(c112600149.distg)
	e7:SetOperation(c112600149.disop)
	c:RegisterEffect(e7)
end
function c112600149.ffilter2(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsLocation(LOCATION_MZONE)
end
function c112600149.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c112600149.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x1e89)
end
function c112600149.indesfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe89)
end
function c112600149.indescon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c112600149.indesfilter,1,nil)
end
function c112600149.indestg(e,c)
	return c:IsSetCard(0xe89) and c:IsType(TYPE_MONSTER)
end
function c112600149.spfilter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c:IsSetCard(0xe89)
end
function c112600149.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c112600149.spfilter(chkc,e,tp,zone) end
	if chk==0 then return zone~=0 and Duel.IsExistingTarget(c112600149.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c112600149.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c112600149.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c112600149.indcon(e)
	return e:GetHandler():IsLinkState()
end
function c112600149.spfilter2(c)
	return c:IsSetCard(0xe89) and c:IsAbleToRemoveAsCost()
end
function c112600149.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112600149.spfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c112600149.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c112600149.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c112600149.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(0,1)
	e2:SetTarget(c112600149.sumlimit)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2,tp)
end
function c112600149.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function c112600149.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_GRAVE)
end
function c112600149.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c112600149.tdfilter(c)
	return c:IsAbleToDeck()
end
function c112600149.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local g=Duel.GetMatchingGroup(c112600149.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c112600149.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c112600149.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
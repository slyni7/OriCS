--欺界裝置(마키나)/正規/348(시르)
function c112600141.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_EARTH),2,2)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112600141,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,112600141)
	e1:SetCondition(c112600141.thcon)
	e1:SetTarget(c112600141.thtg)
	e1:SetOperation(c112600141.thop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112600141,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c112600141.discon)
	e2:SetCost(c112600141.discost)
	e2:SetTarget(c112600141.distg)
	e2:SetOperation(c112600141.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c112600141.incon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e0=e3:Clone()
	e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e0)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,112600141)
	e4:SetCondition(c112600141.tkcn)
	e4:SetTarget(c112600141.tktg)
	e4:SetOperation(c112600141.tkop)
	c:RegisterEffect(e4)
end
function c112600141.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c112600141.thfilter(c)
	return c:IsSetCard(0xe89) and c:IsAbleToHand()
end
function c112600141.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c112600141.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c112600141.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c112600141.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c112600141.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c112600141.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c112600141.cfilter(c,g)
	return c:IsFaceup() and c:IsSetCard(0xe89)
		and g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c112600141.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c112600141.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c112600141.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c112600141.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c112600141.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c112600141.incon(e)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c112600141.tkcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
	and bit.band(c:GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c112600141.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,112600132,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c112600141.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,112600132,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) then
		return
	end
	local token=Duel.CreateToken(tp,112600132)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
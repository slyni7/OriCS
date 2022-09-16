--¿µ¸ÅÈñ ½´ÅÙµµÁö
function c95480915.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14920218,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,95480915)
	e2:SetCondition(c95480915.pcon)
	e2:SetTarget(c95480915.ptg)
	e2:SetOperation(c95480915.pop)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47297616,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,95480985)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c95480915.codisable)
	e3:SetTarget(c95480915.tgdisable)
	e3:SetOperation(c95480915.opdisable)
	c:RegisterEffect(e3)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c95480915.damtg)
	e1:SetOperation(c95480915.damop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.ritlimit)
	c:RegisterEffect(e4)
end
function c95480915.filter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsSummonLocation(LOCATION_EXTRA)
		and c:IsAbleToRemove(tp,POS_FACEDOWN) and c:IsLocation(LOCATION_MZONE)
end
function c95480915.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c95480915.filter,nil,tp)
	local ct=g:GetCount()
	if chk==0 then return ct>0 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
end
function c95480915.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c95480915.filter,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end

function c95480915.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xd42)
end
function c95480915.pfilter(c)
	return c:IsSetCard(0xd42) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c95480915.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c95480915.pfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95480915.pfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c95480915.pfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c95480915.pop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end
function c95480915.codisable(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and rc~=c and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
	and bit.band(re:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:GetSummonLocation()==LOCATION_EXTRA
end
function c95480915.tgdisable(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c95480915.opdisable(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
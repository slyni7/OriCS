--
function c17300005.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x2d1),3)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--destroy and set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,17300005)
	e1:SetCost(c17300005.cost1)
	e1:SetTarget(c17300005.tar1)
	e1:SetOperation(c17300005.op1)
	c:RegisterEffect(e1)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17300005,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,17299995)
	e1:SetTarget(c17300005.drtg)
	e1:SetOperation(c17300005.drop)
	c:RegisterEffect(e1)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(17300005,2))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCondition(c17300005.con4)
	e6:SetTarget(c17300005.tar4)
	e6:SetOperation(c17300005.op4)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(17300005,ACTIVITY_SPSUMMON,c17300005.counterfilter)
end
c17300005.pendulum_level=3
function c17300005.counterfilter(c)
	return c:IsSetCard(0x2d1)
end
function c17300005.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(17300005,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c17300005.splimit)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function c17300005.splimit(e,c)
	return not c:IsSetCard(0x2d1)
end
function c17300005.desfilter(c,tp)
	if c:IsFacedown() then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft==0 and c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 then
		return Duel.IsExistingMatchingCard(c17300005.filter,tp,LOCATION_DECK,0,1,nil,true)
	else
		return Duel.IsExistingMatchingCard(c17300005.filter,tp,LOCATION_DECK,0,1,nil,false)
	end
end
function c17300005.filter(c,ignore)
	return c:IsSetCard(0x2d1) and c:IsType(TYPE_SPELL) and c:IsSSetable(ignore)
end
function c17300005.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c17300005.desfilter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c17300005.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c17300005.desfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c17300005.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then
		return
	end
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c17300005.filter,tp,LOCATION_DECK,0,1,1,nil,false)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c17300005.drfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2d1)
end
function c17300005.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local gc=e:GetHandler():GetLinkedGroup():FilterCount(c17300005.drfilter,nil)
	if chk==0 then return gc>0 and Duel.IsPlayerCanDraw(tp,gc) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,gc)
end
function c17300005.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local gc=e:GetHandler():GetLinkedGroup():FilterCount(c17300005.drfilter,nil)
	if gc>0 then
		Duel.Draw(p,gc,REASON_EFFECT)
	end
end
function c17300005.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c17300005.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c17300005.op4(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--코퀴토
function c95481416.initial_effect(c)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c95481416.eqtg)
	e1:SetOperation(c95481416.eqop)
	c:RegisterEffect(e1)
	--handes
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,95481416)
	e4:SetCondition(c95481416.hdcon)
	e4:SetTarget(c95481416.hdtg)
	e4:SetOperation(c95481416.hdop)
	c:RegisterEffect(e4)
end
function c95481416.eqfilter(c,tp)
	if not c:IsFaceup() then return false end
	if c:IsType(TYPE_TRAPMONSTER) then return Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_CONTROL)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE,tp,0)>=2 end
	return true
end
function c95481416.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c95481416.eqfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c95481416.eqfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c95481416.eqfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(c95481416.limit(g:GetFirst()))
end
function c95481416.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c95481416.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c95481416.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c95481416.eqlimit)
		e1:SetLabelObject(tc)
		c:RegisterEffect(e1)
		--control
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_SET_CONTROL)
		e2:SetValue(tp)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		--Destroy
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EVENT_LEAVE_FIELD_P)
		e3:SetOperation(c95481416.checkop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e4:SetCode(EVENT_LEAVE_FIELD)
		e4:SetOperation(c95481416.desop)
		e4:SetReset(RESET_EVENT+RESET_OVERLAY+RESET_TOFIELD)
		e4:SetLabelObject(e3)
		c:RegisterEffect(e4)
		--up
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_EQUIP)
		e5:SetCode(EFFECT_UPDATE_ATTACK)
		e5:SetValue(1000)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e5)
		local e6=e5:Clone()
		e6:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e6)
	end
end
function c95481416.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c95481416.desop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	if e:GetLabelObject():GetLabel()~=0 then return end
	local tc=e:GetHandler():GetEquipTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end



function c95481416.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c95481416.filter(c)
	return c:IsAbleToRemove()
end
function c95481416.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481416.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c95481416.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c95481416.hdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c95481416.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
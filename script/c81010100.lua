--MMJ Daichi_no_denrei
function c81010100.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEASTWARRIOR),5,2,c81010100.filter,aux.Stringid(81010100,1),3,c81010100.operation)
	c:EnableReviveLimit()
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c81010100.alvl)
	e1:SetCondition(c81010100.alcon)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010100,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c81010100.rmco)
	e2:SetTarget(c81010100.rmtg)
	e2:SetOperation(c81010100.rmop)
	c:RegisterEffect(e2)
	--ATK up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c81010100.atcon)
	e3:SetValue(c81010100.atvl)
	c:RegisterEffect(e3)
end

--xyz
function c81010100.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xca1) and c:GetRank()==4
end
function c81010100.operation(e,tp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,81010100)==0
	end
	Duel.RegisterFlagEffect(tp,81010100,RESET_PHASE+PHASE_END,0,1)
	return true
end

--act limit
function c81010100.alvl(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c81010100.alcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

--remove
function c81010100.rmco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

function c81010100.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c81010100.rmfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c81010100.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(81010100,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,2)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c81010100.rtcn)
		e1:SetOperation(c81010100.rtop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c81010100.rtcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(81010100)~=0
end
function c81010100.rtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end

--ATK up
function c81010100.atcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil and e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xca1)
end
function c81010100.atvl(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE,0,nil,0xca1)*200
end
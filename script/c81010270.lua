--초계반

function c81010270.initial_effect(c)
	
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xca1),1)
	
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81010270,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81010270)
	e1:SetTarget(c81010270.tg)
	e1:SetOperation(c81010270.op)
	c:RegisterEffect(e1)
	
end

--mat
function c81010270.symafilter(c)
	return c:IsType(TYPE_TUNER) and c:IsRace(RACE_BEASTWARRIOR)
	and c:IsCanBeSynchroMaterial()
end

--confirm
function c81010270.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) and chkc:IsFacedown()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_SZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81010270,1))
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_SZONE,1,1,nil)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c81010270.lim(g:GetFirst()))
	end
end
function c81010270.lim(c)
	return function (e,lp,tp)
				return e:GetHandler()~=c
			end
end 

function c81010270.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		e:SetLabelObject(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCondition(c81010270.rcn)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function c81010270.rcn(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end

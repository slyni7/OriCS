--MMJ ST2
function c81010070.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xca1),1,1)
	c:EnableReviveLimit()
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c81010070.rptg)
	e1:SetValue(c81010070.rpvl)
	c:RegisterEffect(e1)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
	--double attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010070,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81010070.dacn)
	e2:SetCost(c81010070.daco)
	e2:SetTarget(c81010070.datg)
	e2:SetOperation(c81010070.daop)
	c:RegisterEffect(e2)
end

--destroy replace
function c81010070.rpfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and (c:IsSetCard(0xca1)) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetFlagEffect(81010070)==0
end
function c81010070.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c81010070.rpfilter,1,nil,tp) end
	local g=eg:Filter(c81010070.rpfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(81010070,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(81010070,1))
		tc=g:GetNext()
	end
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end

function c81010070.rpvl(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end

--double attack
function c81010070.dafilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca1) and c:GetEffectCount(EFFECT_EXTRA_ATTACK)==0
end
function c81010070.dacn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end

function c81010070.dacofilter(c)
	return c:IsSetCard(0xca1) and c:IsAbleToDeckAsCost()
end
function c81010070.daco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010070.dacofilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c81010070.dacofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

function c81010070.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81010070.dafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81010070.dafilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81010070.dafilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c81010070.daop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
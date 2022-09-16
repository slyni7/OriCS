--에퀴녹스 인피니티
function c95480199.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c95480199.matfilter,2,99,c95480199.lcheck)
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c95480199.matcheck)
	c:RegisterEffect(e1)
	--immune reg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c95480199.regcon)
	e2:SetOperation(c95480199.regop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9617996,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,95480199)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c95480199.thcon)
	e3:SetTarget(c95480199.thtg)
	e3:SetOperation(c95480199.thop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,95480198)
	e4:SetCost(c95480199.rmcost)
	e4:SetTarget(c95480199.rmtg)
	e4:SetOperation(c95480199.rmop)
	c:RegisterEffect(e4)
end

function c95480199.matfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c95480199.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c95480199.matcheck(e,c)
	local g=c:GetMaterial()
	local typ=0
	local tc=g:GetFirst()
	while tc do
		typ=bit.bor(typ,bit.band(tc:GetOriginalType(),0x58020c0))
		tc=g:GetNext()
	end
	e:SetLabel(typ)
end
function c95480199.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c95480199.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local typ=e:GetLabelObject():GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c95480199.efilter)
	e1:SetLabel(typ)
	c:RegisterEffect(e1)
	if bit.band(typ,TYPE_RITUAL)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(95480199,0))
	end
	if bit.band(typ,TYPE_FUSION)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(95480199,1))
	end
	if bit.band(typ,TYPE_SYNCHRO)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(95480199,2))
	end
	if bit.band(typ,TYPE_XYZ)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(95480199,3))
	end
	if bit.band(typ,TYPE_PENDULUM)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(95480199,4))
	end
	if bit.band(typ,TYPE_LINK)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(95480199,5))
	end
end
function c95480199.efilter(e,te)
	return te:IsActiveType(e:GetLabel()) and te:GetOwner()~=e:GetOwner()
end


function c95480199.cfilter(c,lg)
	return c:IsType(TYPE_EFFECT) and lg:IsContains(c) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c95480199.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c95480199.cfilter,1,nil,lg)
end
function c95480199.pfilter(c)
	return c:IsAbleToHand()
end
function c95480199.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c95480199.pfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95480199.pfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c95480199.pfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c95480199.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c95480199.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c95480199.cfilter(c,g)
	return g:IsContains(c)
end
function c95480199.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(c95480199.cfilter,tp,LOCATION_MZONE,0,1,nil,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=Duel.SelectMatchingCard(tp,c95480199.cfilter,tp,LOCATION_MZONE,0,1,1,nil,lg):GetFirst()
	if Duel.Remove(rc,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(rc)
		e1:SetCountLimit(1)
		e1:SetOperation(c95480199.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c95480199.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c95480199.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c95480199.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
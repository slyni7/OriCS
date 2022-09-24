--変性ゼリッピ
function c112400003.initial_effect(c)
	--re0(cannot be xyz material)
	local re0=Effect.CreateEffect(c)
	re0:SetType(EFFECT_TYPE_SINGLE)
	re0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	re0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	re0:SetValue(1)
	c:RegisterEffect(re0)
	--pendulum
	if Pendulum then Pendulum.AddProcedure(c) else aux.EnablePendulumAttribute(c) end
	--re1(fusion limit) --2017.06.15 errata
	local re1=Effect.CreateEffect(c)
	re1:SetType(EFFECT_TYPE_SINGLE)
	re1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	re1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	re1:SetValue(c112400003.fuslimit)
	c:RegisterEffect(re1)
	--me1(fus mat)
	local me1=Effect.CreateEffect(c)
	me1:SetDescription(aux.Stringid(112400003,0))
	me1:SetType(EFFECT_TYPE_IGNITION)
	me1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	me1:SetRange(LOCATION_MZONE)
	me1:SetCountLimit(1)
	me1:SetTarget(c112400003.fmtg)
	me1:SetOperation(c112400003.fmop)
	c:RegisterEffect(me1)
	--pe1(def up)
	local pe1=Effect.CreateEffect(c)
	pe1:SetType(EFFECT_TYPE_FIELD)
	pe1:SetCode(EFFECT_UPDATE_DEFENSE)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetTargetRange(LOCATION_ONFIELD,0)
	pe1:SetTarget(aux.TargetBoolFunction(c112400003.deffilter))
	pe1:SetValue(c112400003.defvalue)
	c:RegisterEffect(pe1)
	--pe2(dest toh)
	local pe2=Effect.CreateEffect(c)
	pe2:SetDescription(aux.Stringid(112400003,1))
	pe2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	pe2:SetType(EFFECT_TYPE_IGNITION)
	pe2:SetRange(LOCATION_PZONE)
	pe2:SetCountLimit(1,112400003)
	--pe2:SetCondition(c112400003.thcon)
	pe2:SetTarget(c112400003.thtg)
	pe2:SetOperation(c112400003.thop)
	c:RegisterEffect(pe2)
end
c112400003.listed_series={0x4ec1,0x8ec1}
--re1(fusion limit) --2017.6.15 errata
function c112400003.fuslimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x4ec1) and not c:IsSetCard(0x8ec1)
end
--me1(fus mat)
function c112400003.fmfilter(c,tc)
	local code1,code2=c:GetCode()
	return c:IsSetCard(0x4ec1) and c:IsFaceup() and ((not tc:IsCode(code1)) or (code2 and not tc:IsCode(code2)))
end
function c112400003.fmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc~=c and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)
		and c112400003.fmfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c112400003.fmfilter,tp,LOCATION_MZONE,0,1,c,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c112400003.fmfilter,tp,LOCATION_MZONE,0,1,1,c,c)
end
function c112400003.fmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local code1,code2=tc:GetCode()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_FUSION_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(code1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	if code2 then
		local e2=e1:Clone()
		e2:SetValue(code2)
		c:RegisterEffect(e2)
	end
end
--pe1(def up)
function c112400003.deffilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4ec1)
end
function c112400003.defvalue(e,c)
	return Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_ONFIELD,0):FilterCount(Card.IsType,nil,TYPE_MONSTER)*100
end
--pe2(dest toh)
function c112400003.thfilter(c,code1,code2)
	return c:IsFaceup() and c:IsSetCard(0x4ec1) and bit.band(c:GetType(),0x1000001)==0x1000001
		and c:IsAbleToHand() and not c:IsCode(code1,code2)
end
function c112400003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local pc=Duel.GetFirstMatchingCard(aux.TRUE,tp,LOCATION_PZONE,0,c)
	if chk==0 then return pc and Duel.IsExistingMatchingCard(c112400003.thfilter,tp,LOCATION_EXTRA,0,2,nil,c:GetCode(),pc:GetCode()) end
	local g=Group.FromCards(c,pc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_EXTRA)
end
function c112400003.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pc=Duel.GetFirstMatchingCard(aux.TRUE,tp,LOCATION_PZONE,0,c)
	if not pc then return end
	local dg=Group.FromCards(c,pc)
	if Duel.Destroy(dg,REASON_EFFECT)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c112400003.thfilter,tp,LOCATION_EXTRA,0,2,2,nil,c:GetCode(),pc:GetCode())
	if #g==2 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

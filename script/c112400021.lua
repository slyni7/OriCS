--ゼリッピ変身マント
function c112400021.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1068)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCondition(c112400021.condition)
	e0:SetTarget(c112400021.target)
	e0:SetOperation(c112400021.operation)
	c:RegisterEffect(e0)
	--re0(equip limit)
	local re0=Effect.CreateEffect(c)
	re0:SetType(EFFECT_TYPE_SINGLE)
	re0:SetCode(EFFECT_EQUIP_LIMIT)
	re0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	re0:SetValue(1)
	c:RegisterEffect(re0)
	--e1a(change name)
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_EQUIP)
	e1a:SetCode(EFFECT_CHANGE_CODE)
	e1a:SetValue(112400002)
	c:RegisterEffect(e1a)
	--e1b(control)
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_EQUIP)
	e1b:SetCode(EFFECT_SET_CONTROL)
	e1b:SetValue(c112400021.ctval)
	c:RegisterEffect(e1b)
	--e2(self destroy)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c112400021.descon)
	c:RegisterEffect(e2)
	--e3(search)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112400021,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c112400021.thcost)
	e3:SetTarget(c112400021.thtg)
	e3:SetOperation(c112400021.thop)
	c:RegisterEffect(e3)
end
c112400021.listed_series={0x4ec1,0x6ec1}
c112400021.listed_names={112400002}
c112400021.card_code_list={[112400002]=true}
--Activate
function c112400021.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4ec1)
end
function c112400021.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c112400021.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c112400021.tgfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:IsControler(tp) or c:IsControlerCanBeChanged())
end
function c112400021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c112400021.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c112400021.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c112400021.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	local tc=g:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	if tc:IsControler(tp) then
		e:SetCategory(CATEGORY_EQUIP)
	else
		e:SetCategory(CATEGORY_EQUIP+CATEGORY_CONTROL)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
	end
end
function c112400021.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,c,tc)
	end
end
--e1a(change name)
--e1b(control)
function c112400021.ctval(e,c)
	return e:GetHandlerPlayer()
end
--e2(self destroy)
function c112400021.descon(e)
	return not Duel.IsExistingMatchingCard(c112400021.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler():GetEquipTarget())
end
--e3(search)
function c112400021.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c112400021.thfilter(c)
	return c:IsSetCard(0x6ec1) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c112400021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112400021.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112400021.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c112400021.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

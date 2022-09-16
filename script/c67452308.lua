--사이플루이드 플로트
function c67452308.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetTarget(c67452308.tar1)
	e1:SetOperation(c67452308.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c67452308.val2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_LPCOST_CHANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(c67452308.val3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetCountLimit(1)
	e4:SetDescription(aux.Stringid(67452308,0))
	e4:SetCost(c67452308.cost4)
	e4:SetTarget(c67452308.tar4)
	e4:SetOperation(c67452308.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetDescription(aux.Stringid(67452308,1))
	e5:SetCondition(c67452308.con5)
	e5:SetCost(c67452308.cost5)
	e5:SetTarget(c67452308.tar5)
	e5:SetOperation(c67452308.op5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCost(c67452308.cost6)
	e6:SetOperation(c67452308.op6)
	c:RegisterEffect(e6)
	if not c67452308.global_check then
		c67452308.global_check=true
		c67452308[0]=0
		c67452308[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PAY_LPCOST)
		ge1:SetOperation(c67452308.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c67452308.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c67452308.tfil1(c)
	return c:IsFaceup() and c:IsSetCard(0x2db)
end
function c67452308.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and c67452308.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c67452308.tfil1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c67452308.tfil1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
function c67452308.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c67452308.val2(e,c)
	return c:IsSetCard(0x2db)
end
function c67452308.val3(e,re,rp,val)
	if re and re:IsHasType(0x7e0) and re:GetHandler()==e:GetHandler():GetEquipTarget() then
		return val*2
	else
		return val
	end
end
function c67452308.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,700)
	else
		Duel.PayLPCost(tp,700)
	end
end
function c67452308.tfil4(c,tp)
	return c:IsSetCard(0x2db) and c:IsType(TYPE_MONSTER) and c:GetAttack()<=c67452308[tp]
end
function c67452308.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c67452308.tfil4,tp,LOCATION_DECK,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67452308.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67452308.tfil4,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c67452308.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetEquipTarget():GetAttack()>=Duel.GetLP(tp)
end
function c67452308.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function c67452308.tfil5(c,tp)
	return c:IsSetCard(0x2db) and c:IsAbleToHand() and c:GetAttack()>Duel.GetLP(tp)
end
function c67452308.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c67452308.tfil5,tp,LOCATION_DECK,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67452308.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67452308.tfil5,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c67452308.cfil6(c,tp)
	return c:IsSetCard(0x2db) and c:IsAbleToRemoveAsCost() and c:GetAttack()>Duel.GetLP(tp)
end
function c67452308.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c67452308.cfil6,tp,LOCATION_GRAVE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c67452308.cfil6,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetAttack())
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c67452308.op6(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,e:GetLabel())
end
function c67452308.gop1(e,tp,eg,ep,ev,re,r,rp)
	c67452308[ep]=c67452308[ep]+ev
end
function c67452308.gop2(e,tp,eg,ep,ev,re,r,rp)
	c67452308[0]=0
	c67452308[1]=0
end
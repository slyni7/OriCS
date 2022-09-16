--사이플루이드 플루엘
function c67452306.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PAY_LPCOST)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c67452306.con1)
	e1:SetTarget(c67452306.tar1)
	e1:SetOperation(c67452306.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCountLimit(1)
	e2:SetDescription(aux.Stringid(67452306,0))
	e2:SetCost(c67452306.cost2)
	e2:SetTarget(c67452306.tar2)
	e2:SetOperation(c67452306.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetCountLimit(1)
	e3:SetDescription(aux.Stringid(67452306,1))
	e3:SetCondition(c67452306.con3)
	e3:SetCost(c67452306.cost3)
	e3:SetTarget(c67452306.tar3)
	e3:SetOperation(c67452306.op3)
	c:RegisterEffect(e3)
end
function c67452306.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and Duel.GetLP(tp)<=c:GetAttack()
end
function c67452306.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67452306.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c67452306.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,700)
	else
		Duel.PayLPCost(tp,700)
	end
end
function c67452306.tfil2(c)
	return c:IsSetCard(0x2db) and c:IsAbleToGrave() and not c:IsCode(67452306)
end
function c67452306.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c67452306.tfil2,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c67452306.ofil21(c)
	return c:IsSetCard(0x2db) and c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c67452306.ofil22(c,code)
	return c:IsAbleToHand() and c:IsCode(code)
end
function c67452306.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67452306.tfil2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local tc=g:GetFirst()
	local code=tc:GetCode()
	if Duel.IsExistingMatchingCard(c67452306.ofil21,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c67452306.ofil22,tp,LOCATION_DECK,0,1,nil,code)
		and Duel.SelectYesNo(tp,aux.Stringid(67452306,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c67452306.ofil22,tp,LOCATION_DECK,0,1,1,nil,code)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c67452306.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLP(tp)<=c:GetAttack()
end
function c67452306.cfil31(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2db) and c:IsAbleToRemoveAsCost()
end
function c67452306.cfil32(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x2db) and c:IsAbleToRemoveAsCost()
end
function c67452306.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c67452306.cfil31,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(c67452306.cfil32,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c67452306.cfil31,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c67452306.cfil32,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c67452306.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c67452306.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
end
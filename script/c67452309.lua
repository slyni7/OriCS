--사이플루이드 커렌트
function c67452309.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCost(c67452309.cost1)
	e1:SetTarget(c67452309.tar1)
	e1:SetOperation(c67452309.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c67452309.cost2)
	e2:SetOperation(c67452309.op2)
	c:RegisterEffect(e2)
end
function c67452309.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,700)
	else
		Duel.PayLPCost(tp,700)
	end
end
function c67452309.tfil11(c)
	return c:IsSetCard(0x2db)
end
function c67452309.tfil12(c)
	return c:IsSetCard(0x2db) and c:IsAbleToHand() and not c:IsCode(67452309)
end
function c67452309.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c67452309.tfil11,tp,LOCATION_HAND,0,1,c)
			and Duel.IsPlayerCanDraw(tp,1)
			and Duel.IsExistingMatchingCard(c67452309.tfil12,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67452309.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local dg=Duel.SelectMatchingCard(tp,c67452309.tfil11,tp,LOCATION_HAND,0,1,1,nil)
	if dg:GetCount()>0 then
		Duel.SendtoGrave(dg,REASON_DISCARD+REASON_EFFECT)
	end
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ag=Duel.SelectMatchingCard(tp,c67452309.tfil12,tp,LOCATION_DECK,0,1,1,nil)
	if ag:GetCount()>0 then
		Duel.SendtoHand(ag,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,ag)
	end
end
function c67452309.cfil2(c,tp)
	return c:IsSetCard(0x2db) and c:IsAbleToRemoveAsCost() and c:GetAttack()>Duel.GetLP(tp)
end
function c67452309.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c67452309.cfil2,tp,LOCATION_GRAVE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c67452309.cfil2,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetAttack())
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c67452309.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,e:GetLabel())
end
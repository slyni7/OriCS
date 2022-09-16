--몽시공의 양전자포
--카드군 번호: 0xc97
function c81261030.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,"L",nil,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),aux.FilterBoolFunction(Card.IsSetCard,0xc97))

	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c81261030.cn1)
	e1:SetTarget(c81261030.tg1)
	e1:SetOperation(c81261030.op1)
	c:RegisterEffect(e1)
	
	--내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81261030.cn2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	
	--견제
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCondition(c81261030.cn4)
	e4:SetTarget(c81261030.tg4)
	e4:SetOperation(c81261030.op4)
	c:RegisterEffect(e4)
end
c81261030.CardType_Order=true

--서치
function c81261030.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ORDER)
end
function c81261030.tfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc97) and c:IsType(TYPE_QUICKPLAY)
	and ( c:IsLocation(0x01) or c:IsFaceup() )
end
function c81261030.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81261030.tfil0,tp,0x01+0x20,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01+0x20)
end
function c81261030.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81261030.tfil0,tp,0x01+0x20,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--내성
function c81261030.cn2(e,c)
	return not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),0x10,0,1,nil,TYPE_MONSTER)
end

--견제
function c81261030.cn4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and (re:GetHandler():IsSetCard(0xc97) or re:GetHandler():IsCode(81261000))
end
function c81261030.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,0x0c,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0x0c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x0c)
end
function c81261030.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,0x0c,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Destroy(tc,REASON_EFFECT,0x20)
	end
end

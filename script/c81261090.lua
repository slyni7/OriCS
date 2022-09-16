--몽시공 - 차원 분열
--카드군 번호: 0xc97
function c81261090.initial_effect(c)

	--묘지제외
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81261090,2))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81261090+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81261090.co1)
	e1:SetTarget(c81261090.tg1)
	e1:SetOperation(c81261090.op1)
	c:RegisterEffect(e1)
	--마함제외
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81261090,3))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,81261090+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c81261090.co2)
	e2:SetTarget(c81261090.tg2)
	e2:SetOperation(c81261090.op2)
	c:RegisterEffect(e2)
end

--묘지 제외
function c81261090.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc97)
end
function c81261090.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rt=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,0x10,nil)
	if chk==0 then
		return rt>0 and Duel.IsExistingMatchingCard(c81261090.cfil0,tp,0x02+0x10,0,1,c)
	end
	if rt>3 then rt=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81261090.cfil0,tp,0x02+0x10,0,1,rt,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(#g)
end
function c81261090.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,0x10,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x08+0x10)
end
function c81261090.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct<=0 then
		return
	end
	local cg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,0x10,nil)
	if #cg>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=cg:Select(tp,ct,ct,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT,false)
	end
end

--묘지 제외
function c81261090.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rt=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,0x08,nil)
	if chk==0 then
		return rt>0 and Duel.IsExistingMatchingCard(c81261090.cfil0,tp,0x02+0x10,0,1,c)
	end
	if rt>3 then rt=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81261090,tp,0x02+0x10,0,1,rt,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(#g)
end
function c81261090.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,0x08,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x08+0x10)
end
function c81261090.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct<=0 then
		return
	end
	local cg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,0x08,nil)
	if #cg>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=cg:Select(tp,ct,ct,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT,false)
	end
end

--인스톨 오메가
function c76859416.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76859416,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCountLimit(1,76859416+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c76859416.tg1)
	e1:SetOperation(c76859416.op1)
	c:RegisterEffect(e1)
	if not c76859416.global_check then
		c76859416.global_check=true
	end
end
function c76859416.tfilter1(c)
	return c:IsSetCard(0x2c1) and c:IsDestructable() and c:IsFaceup() and not c:IsCode(76859416)
end
function c76859416.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingTarget(c76859416.tfilter1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c76859416.tfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,2,2,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c76859416.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
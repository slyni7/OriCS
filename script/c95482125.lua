--알피스트 네레아그랑데
function c95482125.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,95482101,aux.FilterBoolFunction(Card.IsFusionType,TYPE_LINK),1,true,true)
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26205777,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c95482125.condition)
	e1:SetTarget(c95482125.target)
	e1:SetOperation(c95482125.operation)
	c:RegisterEffect(e1)
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c95482125.atkval)
	c:RegisterEffect(e2)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c95482125.splimit)
	c:RegisterEffect(e0)
end
function c95482125.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsSetCard(0xd5a)
end
function c95482125.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c95482125.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c95482125.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		local tc=sg:GetFirst()
		if tc:IsType(TYPE_MONSTER) then
			local g2=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_DECK)
			local tg=g2:Filter(Card.IsCode,nil,tc:GetCode())
			if tg:GetCount()>0 then
				Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
function c95482125.atkval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_REMOVED)*-200
end
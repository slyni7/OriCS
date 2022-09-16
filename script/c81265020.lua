--오덱시즈 세리
--카드군 번호: 0xc91
function c81265020.initial_effect(c)

	--특수소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81265020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,81265020)
	e1:SetCondition(c81265020.cn1)
	e1:SetTarget(c81265020.tg1)
	e1:SetOperation(c81265020.op1)
	c:RegisterEffect(e1)
	
	--내성
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81265020,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,81265020)
	e2:SetOperation(c81265020.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end

--특수소환
function c81265020.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc91)
end
function c81265020.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81265020.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81265020.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c81265020.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1,true)
	end
end

--내성
function c81265020.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81265020,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc91))
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.tgoval)
	Duel.RegisterEffect(e2,tp)
end



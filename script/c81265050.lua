--오덱시즈 액션
--카드군 번호: 0xc91
function c81265050.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81265050,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81265050+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81265050.tg1)
	e1:SetOperation(c81265050.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(81265050,0))
	e2:SetTarget(c81265050.tg2)
	e2:SetOperation(c81265050.op2)
	c:RegisterEffect(e2)
	
	--파괴회피
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c81265050.tg3)
	e3:SetValue(c81265050.val)
	e3:SetOperation(c81265050.op3)
	c:RegisterEffect(e3)
end

--발동
function c81265050.xyzfil(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0xc91)
end
function c81265050.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c81265050.xyzfil,tp,LOCATION_EXTRA,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c81265050.op1(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetMatchingGroup(c81265050.xyzfil,tp,LOCATION_EXTRA,0,nil)
	if g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g2:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end

function c81265050.ordfil(c)
	return (c:IsSpecialSummonable(SUMMON_TYPE_ORDER) 
	or c:IsSpecialSummonable(SUMMON_TYPE_ORDER_L) or c:IsSpecialSummonable(SUMMON_TYPE_ORDER_R))
	and c:IsSetCard(0xc91)
end
function c81265050.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c81265050.ordfil,tp,0x40,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)
end
function c81265050.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81265050.ordfil,tp,0x40,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SpecialSummonRule(tp,tc,tc:GetSummonType())
end

--파괴회피
function c81265050.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc91) and c:IsType(TYPE_MONSTER)
	and c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c81265050.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsAbleToRemove() and eg:IsExists(c81265050.cfilter,1,nil,tp)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c81265050.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end



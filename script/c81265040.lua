--오덱시즈 마기아
--카드군 번호: 0xc91
function c81265040.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,"L",nil,c81265040.mat0,c81265040.mat1)
	
	--오더소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81265040,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,81265040)
	e1:SetCondition(c81265040.cn1)
	e1:SetOperation(c81265040.op1)
	e1:SetValue(SUMMON_TYPE_ORDER)
	c:RegisterEffect(e1)
	
	--묘지견제
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81265040,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,81265041)
	e2:SetCondition(c81265040.cn2)
	e2:SetTarget(c81265040.tg2)
	e2:SetOperation(c81265040.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c81265040.val)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	
	--내성
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81265040,4))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c81265040.cn3)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	
	--프리체인
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(81265040,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c81265040.co6)
	e6:SetTarget(c81265040.tg6)
	e6:SetOperation(c81265040.op6)
	c:RegisterEffect(e6)
end
c81265040.CardType_Order=true

--소재
function c81265040.mat0(c)
	return c:IsRace(RACE_THUNDER)
end
function c81265040.mat1(c)
	return c:IsRace(RACE_THUNDER) and c:IsType(TYPE_EFFECT)
end

--오더소환
function c81265040.cfilter(c,fc,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xc91)
	and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,c,fc)>0
end
function c81265040.cn1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,c81265040.cfilter,1,nil,c,tp)
end
function c81265040.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c81265040.cfilter,1,1,nil,c,tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_ORDER+REASON_MATERIAL)
end

--묘지견제
function c81265040.cn2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ORDER) and e:GetLabel()==1
end
function c81265040.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_GRAVE,1,nil)
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c81265040.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_GRAVE,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end

function c81265040.val(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_XYZ) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end

--내성
function c81265040.cn3(e)
	return e:GetLabel()==1
end

--서치
function c81265040.filter0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc91) and c:IsType(TYPE_MONSTER)
end
function c81265040.co6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81265040.filter0,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81265040.filter0,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81265040.filter1(c)
	return c:IsSSetable() and c:IsSetCard(0xc91) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81265040.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c81265040.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
	end
end
function c81265040.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c81265040.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		if tc:IsType(TYPE_TRAP) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end



--오덱시즈 엑시아
--카드군 번호: 0xc91
function c81265030.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_THUNDER),4,2,c81265030.mfilter0,aux.Stringid(81265030,3),2,c81265030.mop)
	
	--필드클린
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81265030,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,81265030)
	e1:SetCondition(c81265030.cn1)
	e1:SetTarget(c81265030.tg1)
	e1:SetOperation(c81265030.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c81265030.va2)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	
	--내성
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c81265030.cn3)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	
	--서치
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81265030,1))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c81265030.co4)
	e4:SetTarget(c81265030.tg4)
	e4:SetOperation(c81265030.op4)
	c:RegisterEffect(e4)
end

--소재
function c81265030.mfilter0(c)
	return c:IsFaceup() and c:IsSetCard(0xc91) and c:IsType(TYPE_ORDER)
end
function c81265030.mop(e,tp,chk)
	if chk==0 then	
		return Duel.GetFlagEffect(tp,81265030)==0
	end
	Duel.RegisterFlagEffect(tp,81265030,RESET_PHASE+PHASE_END,0,1)
end

--필드클린
function c81265030.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function c81265030.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*300)
end
function c81265030.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	local sg=Duel.GetOperatedGroup()
	if sg:GetCount()>0 then
		Duel.Damage(1-tp,sg:GetCount()*300,REASON_EFFECT)
	end
end

function c81265030.cfilter(c)
	return c:IsType(TYPE_ORDER)
end
function c81265030.va2(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c81265030.cfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end


--내성
function c81265030.cn3(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_ORDER)
end

--서치
function c81265030.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c81265030.filter0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc91) and c:IsType(TYPE_MONSTER)
end
function c81265030.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81265030.filter0,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c81265030.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81265030.filter0,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end



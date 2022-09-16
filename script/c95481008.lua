--생츄어리 아니마기아스
function c95481008.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd5e),aux.NonTuner(Card.IsSetCard,0xd5e),1,1)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c95481008.condition)
	e1:SetValue(c95481008.efilter)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_FZONE,0)
	e2:SetTarget(c95481008.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(56804361,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,95481008)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c95481008.cost)
	e3:SetTarget(c95481008.eqtg)
	e3:SetOperation(c95481008.eqop)
	c:RegisterEffect(e3)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(95481008,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	e0:SetCondition(c95481008.sprcon)
	e0:SetOperation(c95481008.sprop)
	c:RegisterEffect(e0)
end
function c95481008.tgrfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost()
end
function c95481008.tgrfilter1(c)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0xd5e)
end
function c95481008.tgrfilter2(c)
	return not c:IsType(TYPE_TUNER)
end
function c95481008.mnfilter(c,g)
	return g:IsExists(c95481008.mnfilter2,1,c,c)
end
function c95481008.mnfilter2(c,mc)
	return c:GetLevel()-mc:GetLevel()==6
end
function c95481008.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(c95481008.tgrfilter1,1,nil) and g:IsExists(c95481008.tgrfilter2,1,nil)
		and g:IsExists(c95481008.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c95481008.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c95481008.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c95481008.fselect,2,2,tp,c)
end
function c95481008.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c95481008.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,c95481008.fselect,false,2,2,tp,c)
	Duel.SendtoGrave(tg,REASON_COST)
end

function c95481008.confilter(c)
	return c:IsFaceup() and c:IsCode(95481011)
end
function c95481008.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c95481008.confilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c95481008.efilter(e,re)
	return re:GetOwner()~=e:GetOwner() and re:IsActivated()
end
function c95481008.tgtg(e,c)
	return c~=e:GetHandler()
end


function c95481008.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0xd5e) 
end
function c95481008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95481008.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c95481008.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c95481008.spfilter(c,e,tp)
	return c:IsSetCard(0xd5e) and not c:IsCode(95481008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95481008.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c95481008.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c95481008.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c95481008.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(c95481008.thop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
	end
end
function c95481008.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
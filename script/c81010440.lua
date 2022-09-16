--Fire Caller

function c81010440.initial_effect(c)

	--summon method
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xca1),2,2,c81010440.mat)
	
	--tuner
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,81010440)
	e1:SetCondition(c81010440.tucn)
	e1:SetTarget(c81010440.tutg)
	e1:SetOperation(c81010440.tuop)
	c:RegisterEffect(e1)
	
	--status
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81010440.stcn)
	e2:SetOperation(c81010440.stop)
	c:RegisterEffect(e2)
	
end

--summon method
function c81010440.mat(g)
	return g:GetClassCount(Card.GetAttribute)==g:GetCount()
end

--tuner
function c81010440.tucn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function c81010440.tutgfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsLevelBelow(4) and c:IsSetCard(0xca1)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81010440.tutg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81010440.tutgfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function c81010440.tuop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81010440.tutgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--status
function c81010440.stcnfilter(c,g)
	return g:IsContains(c) and c:IsSetCard(0xca1)
end
function c81010440.stcn(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(c81010440.stcnfilter,1,nil,lg)
end

function c81010440.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then
		return
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end

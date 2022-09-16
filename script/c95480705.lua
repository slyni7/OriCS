--소울 서머너
function c95480705.initial_effect(c)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26034577,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(c95480705.rmcost)
	e4:SetTarget(c95480705.rmtg)
	e4:SetOperation(c95480705.rmop)
	c:RegisterEffect(e4)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67120578,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c95480705.spcon)
	e2:SetTarget(c95480705.sptg)
	e2:SetOperation(c95480705.spop)
	c:RegisterEffect(e2)
end
function c95480705.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c95480705.spfilter(c,e,tp)
	return c:IsSetCard(0xd4a) and c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480705.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c95480705.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c95480705.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local ct=math.min(2,Duel.GetLocationCount(tp,LOCATION_MZONE))
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95480705.spfilter,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c95480705.spop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	local ct=g:GetCount()
	if ct>0 and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133)) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
	end
end
function c95480705.cfilter(c)
	return c:IsRace(RACE_ZOMBIE) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c95480705.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c95480705.cfilter,1,e:GetHandler()) end
	local sg=Duel.SelectReleaseGroup(tp,c95480705.cfilter,1,1,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c95480705.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c95480705.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

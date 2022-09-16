--데우스 엑스 아니마기아스
function c95481010.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd5e),aux.NonTuner(Card.IsSetCard,0xd5e),1,1)
	c:EnableReviveLimit()
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95481010+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c95481010.thtg)
	e2:SetOperation(c95481010.thop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c95481010.condition)
	e3:SetTarget(c95481010.rmtarget)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_DECK,LOCATION_HAND+LOCATION_DECK)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	--special summon rule
	local e0=Effect.CreateEffect(c)
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
	return c:GetLevel()-mc:GetLevel()==8
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

function c95481010.rmtarget(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c95481010.cfilter(c)
	return c:IsFaceup() and c:IsCode(95481011)
end
function c95481010.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c95481010.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c95481010.thfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0xd5e) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c95481010.thfilter1(c,e)
	return c95481010.thfilter(c) and c:IsCanBeEffectTarget(e)
end
function c95481010.thfilter2(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c95481010.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c95481010.thfilter(chkc) end
	local ct1=Duel.GetMatchingGroupCount(c95481010.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	local ct2=Duel.GetMatchingGroupCount(c95481010.thfilter2,tp,0,LOCATION_GRAVE,nil)
	if chk==0 then return ct1>0 and ct2>0 end
	local ct=math.min(ct1,ct2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c95481010.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function c95481010.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if ct>0 and Duel.IsExistingMatchingCard(c95481010.thfilter2,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,ct,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local hg=Duel.SelectMatchingCard(tp,c95481010.thfilter2,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,ct,ct,nil)
			Duel.HintSelection(hg)
			Duel.Remove(hg,POS_FACEUP,REASON_EFFECT)
		end
	end
end

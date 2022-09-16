--원초의 제룡
function c95480424.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95480824,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95480424)
	e1:SetCost(c95480424.cost)
	e1:SetTarget(c95480424.destg)
	e1:SetOperation(c95480424.desop)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(54241725,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,95480476)
	e3:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	e3:SetCost(c95480424.spcost)
	e3:SetTarget(c95480424.sptg)
	e3:SetOperation(c95480424.spop)
	c:RegisterEffect(e3)
end
function c95480424.cfilter(c)
	return c:IsSetCard(0xd45) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c95480424.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480424.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c95480424.cfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c95480424.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c95480424.desfilter(c)
	return c:IsSetCard(0xd45) and c:IsLocation(LOCATION_GRAVE)
end
function c95480424.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c95480424.desfilter,nil)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct~=0 and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95480424,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sdg=dg:Select(tp,1,ct,nil)
		Duel.HintSelection(sdg)
		Duel.Destroy(sdg,REASON_EFFECT)
	end
end

function c95480424.cfilter2(c)
	return c:IsSetCard(0xd45) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c95480424.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480424.cfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c95480424.cfilter2,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c95480424.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,95480424,0,0x11,300,3000,10,RACE_WYRM,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c95480424.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,95480424,0,0x11,300,3000,10,RACE_WYRM,ATTRIBUTE_FIRE) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end

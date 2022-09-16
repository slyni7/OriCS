--유키-처음의 노래소리
function c84320007.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x7a0),1)
	c:EnableReviveLimit()
	--pendulum summon
	 aux.EnablePendulumAttribute(c)
	--win
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84320007,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c84320007.ctcon)
	e1:SetOperation(c84320007.ctop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84320007,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c84320007.operation)
	c:RegisterEffect(e2)
	 --special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c84320007.spcon)
	e3:SetTarget(c84320007.sptg)
	e3:SetOperation(c84320007.spop)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(84320007,2))
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c84320007.cost)
	e4:SetTarget(c84320007.target)
	e4:SetOperation(c84320007.op)
	c:RegisterEffect(e4)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(84320007,3))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c84320007.remcost)
	e5:SetTarget(c84320007.remtg)
	e5:SetOperation(c84320007.remop)
	c:RegisterEffect(e5)
	--pendulum set
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(84320007,7))
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA)
	e6:SetTarget(c84320007.retcon)
	e6:SetTarget(c84320007.rettg)
	e6:SetOperation(c84320007.retop)
	c:RegisterEffect(e6)
	--act limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_PZONE)
	e7:SetTargetRange(0,1)
	e7:SetValue(c84320007.aclimit)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetRange(LOCATION_PZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetTarget(c84320008.tg)
	e8:SetValue(aux.tgoval)
	c:RegisterEffect(e8)
end	
	
	
function c84320007.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c84320007.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCounter(0x1234)>=200 then
		Duel.Win(tp,0x80)
	end
end


function c84320007.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1234,1)
		tc=g:GetNext()
	end
end


function c84320007.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)) and not c:IsLocation(LOCATION_DECK)
end
function c84320007.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x7a0) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84320007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84320007.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c84320007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c84320007.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


function c84320007.dfilter(c)
	return c:IsSetCard(0x7a0) and c:IsType(TYPE_MONSTER) and c:IsDestructable() 
end
function c84320007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84320007.dfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c84320007.dfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Destroy(g,REASON_COST)
end
function c84320007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c84320007.op(e,c)
	local rt=Duel.GetCounter(0,1,1,0x1234)*100
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rt,REASON_EFFECT)
end


function c84320007.remcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1234,15,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1234,15,REASON_COST)
end
function c84320007.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
end
function c84320007.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_DECK,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and (g2:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(84320007,4))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,3,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(84320007,5))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,3,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end






function c84320007.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup()
end
function c84320007.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)
	end
end
function c84320007.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end

function c84320007.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(38834303)
end

function c84320007.tg(e,c)
	return c:IsSetCard(0x7a0) and c:IsDefensePos()
end
function c81010450.initial_effect(c)

	--summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xca1),2,3,c81010450.mat)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c81010450.lim)
	e1:SetValue(c81010450.limv)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010450,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81010450)
	e2:SetTarget(c81010450.gatg)
	e2:SetOperation(c81010450.gaop)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81010450,1))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81010451)
	e3:SetCondition(c81010450.dscn)
	e3:SetCost(c81010450.dsco)
	e3:SetTarget(c81010450.dstg)
	e3:SetOperation(c81010450.dsop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(81010450,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c81010450.cn)
	e4:SetTarget(c81010450.tg)
	e4:SetOperation(c81010450.op)
	c:RegisterEffect(e4)
	
end

--summon
function c81010450.mat(g,lc)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK)
end

--act limit
function c81010450.lim(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

function c81010450.limv(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

--update
function c81010450.gatgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca1) and c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave()
end
function c81010450.gatg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_EXTRA) and c:IsControler(tp) and c81010450.gatgfilter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81010450.gatgfilter,tp,LOCATION_EXTRA,0,1,nil)
	end
	local g=Duel.GetMatchingGroup(c81010450.gatgfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end

function c81010450.gaop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81010450.gatgfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()<1 then
		return
	end
	local ct=Duel.SendtoGrave(g,REASON_EFFECT)
	local c=e:GetHandler()
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(ct*500)
		c:RegisterEffect(e1)
	end
end

--reduct
function c81010450.dscn(e,tp,eg,ep,ev,re,r,rp)
	return ( tp~=ep and eg:GetCount()==1 and Duel.GetCurrentChain()==0 )
end

function c81010450.dscofilter(c)
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0xca1)
end
function c81010450.dsco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81010450.dscofilter,tp,LOCATION_GRAVE,0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c81010450.dscofilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

function c81010450.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end

function c81010450.dsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end


function c81010450.cn(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
	and Duel.IsChainNegatable(ev)
end
function c81010450.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end

function c81010450.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
	end
end

--천명신 돌로어
function c95480313.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),6,2)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(63737050,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c95480313.damcon)
	e1:SetOperation(c95480313.damop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95480313)
	e2:SetCondition(c95480313.condition)
	e2:SetCost(c95480313.cost)
	e2:SetTarget(c95480313.target)
	e2:SetOperation(c95480313.activate)
	c:RegisterEffect(e2)
	if c95480313.counter==nil then
		c95480313.counter=true
		c95480313[0]=0
		c95480313[1]=0
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e3:SetOperation(c95480313.resetcount)
		Duel.RegisterEffect(e3,0)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		e4:SetOperation(c95480313.addcount)
		Duel.RegisterEffect(e4,0)
	end
end
function c95480313.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c95480313[0]=0
	c95480313[1]=0
end
function c95480313.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		c95480313[1-tc:GetSummonPlayer()]=c95480313[1-tc:GetSummonPlayer()]+1
		tc=eg:GetNext()
	end
end

function c95480313.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c95480313.damcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c95480313.cfilter,1,nil,tp) 
				and e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_TRAP)
end
function c95480313.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,c95480313[tp]*100,REASON_EFFECT)
end

function c95480313.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and (re:GetCode()==EVENT_SPSUMMON_SUCCESS or re:GetCode()==EVENT_SUMMON_SUCCESS) and Duel.IsChainNegatable(ev)
end
function c95480313.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c95480313.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
	local atk=re:GetHandler():GetTextAttack()
	if atk<0 then atk=0 end
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	end
end
function c95480313.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if Duel.Destroy(eg,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end


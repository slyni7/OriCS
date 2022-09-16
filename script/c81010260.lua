--MMJ: Baku-sui sei

function c81010260.initial_effect(c)
	
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xca1),2)
	
	--only synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	
	--cannot be targetted
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c81010260.cnvl)
	c:RegisterEffect(e2)
	--cannot be destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c81010260.cdvl)
	c:RegisterEffect(e3)
	
	--ATK / DEF update
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c81010260.adcn)
	e4:SetValue(c81010260.advl)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	
	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(81010260,0))
	e6:SetCategory(CATEGORY_DISABLE+CATEGORY_TODECK)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(2)
	e6:SetCondition(c81010260.ngcn)
	e6:SetCost(c81010260.ngco)
	e6:SetTarget(c81010260.ngtg)
	e6:SetOperation(c81010260.ngop)
	c:RegisterEffect(e6)
	
end

--cannot be tg / ds
function c81010260.cnvl(e,re,rp)
	return rp~=e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end

function c81010260.cdvl(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end

--ATK / DEF update
function c81010260.adcn(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler())
		and Duel.GetAttackTarget()~=nil
end

function c81010260.advl(e,c)
		if e:GetHandler():GetBattleTarget():IsType(TYPE_XYZ) then
		return e:GetHandler():GetBattleTarget():GetRank()*100
	else
		return e:GetHandler():GetBattleTarget():GetLevel()*100
	end
end

--negate
function c81010260.ngcn(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev)
end

function c81010260.ngcofilter(c)
	return c:IsAbleToGraveAsCost() and ( c:IsLocation(LOCATION_HAND) or c:IsFaceup() )
	and ( c:GetType()&TYPE_RITUAL+TYPE_SPELL==TYPE_RITUAL+TYPE_SPELL
	or c:IsSetCard(0xca1) and c:IsType(TYPE_MONSTER)
	)
end
function c81010260.ngco(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c81010260.ngcofilter,tp,loc,0,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81010260.ngcofilter,tp,loc,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c81010260.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD)
end

function c81010260.ngop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
			if ct==1 then
				Duel.ShuffleDeck(1-tp)
			end
		end
	end
end

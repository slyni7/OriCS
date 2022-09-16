--단원5 키사라기 모모
function c95480205.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--eff gain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16313112,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c95480205.effcost)
	e1:SetOperation(c95480205.effop)
	c:RegisterEffect(e1)
end
function c95480205.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c95480205.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c95480205.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c95480205.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		--must attack
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		--atk limit
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetValue(c95480205.atlimit)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		--destroy
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(20366274,1))
		e3:SetCategory(CATEGORY_TODECK)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_BATTLE_START)
		e3:SetCondition(c95480205.descon)
		e3:SetTarget(c95480205.destg)
		e3:SetOperation(c95480205.desop)
		c:RegisterEffect(e3)	
	end
end
function c95480205.atlimit(e,c)
	return c~=e:GetHandler()
end
function c95480205.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL) and c==Duel.GetAttackTarget()
end
function c95480205.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c95480205.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.SendtoDeck(bc,nil,2,REASON_EFFECT)
	end
end
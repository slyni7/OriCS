--알피스트 무스펠하이드
function c95482126.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,95482101,aux.FilterBoolFunction(Card.IsFusionType,TYPE_RITUAL),1,true,true)
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c95482126.condition)
	e1:SetValue(c95482126.aclimit)
	c:RegisterEffect(e1)
	--chain attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72989439,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c95482126.atcon)
	e2:SetOperation(c95482126.atop)
	c:RegisterEffect(e2)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c95482126.splimit)
	c:RegisterEffect(e0)
end
function c95482126.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsSetCard(0xd5a)
end
function c95482126.condition(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c95482126.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c95482126.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return Duel.GetAttacker()==c and c:IsRelateToBattle() and bc:IsType(TYPE_MONSTER) and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and c:IsChainAttackable()
end
function c95482126.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c95482126.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetAttack()
		if dam<0 then dam=0 end
		local atk=Duel.Damage(p,dam,REASON_EFFECT)
			if atk>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(atk)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				c:RegisterEffect(e1)
			end
		end
	Duel.ChainAttack()
end

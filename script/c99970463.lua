--[Aranea]
local m=99970463
local cm=_G["c"..m]
function cm.initial_effect(c)

	--자가 소생
	local e1=MakeEff(c,"I","HG")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--전투 데미지 배가
	local e2=MakeEff(c,"Qo","M")
	e2:SetD(m,0)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
	--공격 강제
	local e4=MakeEff(c,"F","M")
	e4:SetCode(EFFECT_MUST_ATTACK)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(cm.tar4)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e3:SetValue(cm.atklimit)
	c:RegisterEffect(e3)
	
	--공수 증감
	local e5=Effect.CreateEffect(c)
	e5:SetD(m,1)
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetCountLimit(1)
	e5:SetOperation(cm.atkop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e6)
	
end

--자가 소생
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe14) and c:IsType(TYPE_TUNER)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) or not tc:IsType(TYPE_TUNER) then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMOVE_TYPE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(TYPE_TUNER)
	tc:RegisterEffect(e1)
end

--전투 데미지 배가
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.IsAbleToEnterBP() or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function cm.dbfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe14) and c:GetFlagEffect(m)==0
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.dbfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.dbfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.dbfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetCondition(cm.damcon)
		e1:SetOperation(cm.damop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end

--공격 강제
function cm.tar4(e,c)
	local def=e:GetHandler():GetDefense()
	return (c:GetAttack()<def or (c:GetDefense()<def and not c:IsType(TYPE_LINK)))
end
function cm.atklimit(e,c)
	return c==e:GetHandler()
end

--공수 증감
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-100)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=g:GetNext()
		end
	end
end

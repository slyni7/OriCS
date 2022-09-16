--[Aranea]
local m=99970367
local cm=_G["c"..m]
function cm.initial_effect(c)

	--공격력 감소 + 특수 소환
	local e1=MakeEff(c,"Qo","H")
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--공수 증가 + 튜너 제거
	local e2=MakeEff(c,"STo")
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

	--샐비지
	local e4=MakeEff(c,"I","M")
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCL(1,m+YuL.dif)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)

	--공수 증감
	local e5=MakeEff(c,"FTf","M")
	e5:SetD(m,1)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetCL(1)
	e5:SetOperation(cm.atkop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e6)
	
end

--공격력 감소 + 특수 소환
function cm.tar1fil(c)
	return c:IsFaceup() and c:IsSetCard(0xe14) and Duel.IsExistingTarget(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.tar1fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,cm.tar1fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1)
	g1:Merge(g2)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and #tg>0 then
		Duel.BreakEffect()
		local tc=tg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-700)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc=tg:GetNext()
		end
	end
end

--공수 증가 + 튜너 제거
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function cm.tar2fil(c)
	return c:IsFaceup() and c:IsSetCard(0xe14) and c:IsType(TYPE_TUNER) 
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.tar2fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar2fil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.tar2fil,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_REMOVE_TYPE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e3)
	end
end

--샐비지
function cm.tar4fil(c,e)
	return c:IsSetCard(0xe14) and c:IsAbleToHand()
end
function cm.tar4fil2(c,def)
	return c:IsFaceup() and (c:GetAttack()<def or c:GetDefense()<def)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tar4fil(chkc) end
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(cm.tar4fil2,tp,0,LOCATION_MZONE,nil,c:GetDefense())-1
	if chk==0 then return Duel.IsExistingTarget(cm.tar4fil,tp,LOCATION_GRAVE,0,1,nil) and ct>0 end
	local g=Duel.GetMatchingGroup(cm.tar4fil,tp,LOCATION_GRAVE,0,c):Filter(Card.IsCanBeEffectTarget,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,tg:GetCount(),0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
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

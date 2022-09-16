--[Aranea]
local m=99970470
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	YuL.Activate(c)
	
	--드로우 / 튜너 제거 / 공격력 감소
	local e1=MakeEff(c,"I","S")
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

	--효과 내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(cm.efilter)
	e2:SetTarget(cm.etarget)
	c:RegisterEffect(e2)

	--상대가 처음으로 발동한 카드 종류 체크
	if not cm.global_check then
		cm.global_check={}
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
	end

end

--상대가 처음으로 발동한 카드 종류 체크
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if cm[rp]==0 then
		cm[rp]=re:GetActiveType()&0x7
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end

--드로우 / 튜너 제거 / 공격력 감소
function cm.dafilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe14) and c:IsType(TYPE_TUNER)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.dafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.dafilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.dafilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if c:IsRelateToEffect(e) and Duel.Draw(tp,1,REASON_EFFECT)>0 and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(-200)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_TUNER)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end

--효과 내성 부여
function cm.etarget(e,c)
	return c:IsSetCard(0xe14)
end
function cm.efilter(e,te)
	local tp=e:GetOwnerPlayer()
	return te:GetHandlerPlayer()~=tp and cm[1-tp]>0 and te:IsActiveType(cm[1-tp])
end

--[ [ Matryoshka ] ]
local m=99970095
local cm=_G["c"..m]
function cm.initial_effect(c)

	--엑시즈 소환
	RevLim(c)
	aux.AddXyzProcedure(c,aux.FBF(Card.IsSetCard,0xd37),7,2, cm.ovfilter,aux.Stringid(m,3))
	
	--마트료시카
	YuL.MatryoshkaProcedure(c,cm.MatryoshkaMaterial,nil,SUMT_X)
	YuL.MatryoshkaOpen(c,m)
	
	--효과 부여
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(m,0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(spinel.rmovcost(1))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--공수 증가
	local e2=MakeEff(c,"S","M")
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	
end

--엑시즈 소환
function cm.ovfilter(c)
	return c:IsSetCard(0xd37) and c:IsFaceup() and c:GetOriginalLevel()>=5
		and not (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
end

--효과 부여
function tar1fil(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tar1fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar1fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,TYPE_MONSTER)
	e:SetLabel(ac)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.tar1fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ac=e:GetLabel()
	if tc:IsRelateToEffect(e) then
		tc:SetHint(CHINT_CARD,ac)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetD(m,1)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(cm.op1con)
		e1:SetTarget(cm.op1tar)
		e1:SetOperation(cm.op1op)
		e1:SetLabel(ac)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EVENT_FLIP)
		tc:RegisterEffect(e3)
	end
end
function cm.op1confil(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function cm.op1con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.op1confil,1,nil,e:GetLabel())
end
function cm.op1tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(cm.op1confil,nil,e:GetLabel())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function cm.op1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(cm.op1confil,nil,e:GetLabel()):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		g:AddCard(c)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

--공수 증가
function cm.val2(e)
	return Duel.GetOverlayCount(e:GetHandlerPlayer(),1,1)*800
end

--[Aranea]
local m=99970474
local cm=_G["c"..m]
function cm.initial_effect(c)

	--엑시즈 소환
	RevLim(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xe14),5,2)
	
	--드로우
	local e1=MakeEff(c,"I","M")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetCountLimit(1,m)
	e1:SetCost(spinel.rmovcost(1))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--튜너 제거 / 파괴 내성 부여
	local e2=MakeEff(c,"Qo","M")
	e2:SetD(m,1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	--공수 증감
	local e5=Effect.CreateEffect(c)
	e5:SetD(m,2)
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

--드로우
function cm.filter(c)
	return c:IsSetCard(0xe14) and c:IsType(YuL.ST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,cm.filter,1,1,REASON_EFFECT)~=0 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end

--튜너 제거 / 파괴 내성 부여
function cm.dafilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.dafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.dafilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.dafilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e0=e1:Clone()
		e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e0)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_TUNER)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end

--공수 증감
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if g1:GetCount()>0 then
		local sg=g1:GetFirst()
		while sg do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.atv1)
			sg:RegisterEffect(e1)
			sg=g1:GetNext()
		end
	end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.atv2)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=g:GetNext()
		end
	end
end
function cm.atv1(e,c)
	local lv=0
	if c:IsType(TYPE_XYZ) then lv=c:GetRank() else lv=c:GetLevel() end
	return lv*50
end
function cm.atv2(e,c)
	local lv=0
	if c:IsType(TYPE_XYZ) then lv=c:GetRank() else lv=c:GetLevel() end
	return lv*-100
end

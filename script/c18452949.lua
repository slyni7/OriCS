--ÇÏÀÌ¿£Á© - ¸®»ç ´õ ¹ÂÁ÷¢Ü
local m=18452949
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.pfil1,cm.pfun1,3,3)
	local e1=MakeEff(c,"FC","M")
	e1:SetCode(EVENT_CHAIN_SOLVING)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
end
function cm.pfil1(c,xc)
	return c:IsXyzLevel(xc,4)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={0x0,ATTRIBUTE_LIGHT,ATTRIBUTE_WIND,ATTRIBUTE_FIRE}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)>0 or not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		return
	end
	if re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) then
		Duel.Hint(HINT_CARD,0,m)
		if Duel.NegateEffect(ev) then
			c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
			c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
		end
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m+1)>0 or not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		return
	end
	if re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainDisablable(ev) then
		Duel.Hint(HINT_CARD,0,m)
		if Duel.NegateEffect(ev) then
			c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
			c:RegisterFlagEffect(m+1,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
		end
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m+2)>0 or not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		return
	end
	if re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainDisablable(ev) then
		Duel.Hint(HINT_CARD,0,m)
		if Duel.NegateEffect(ev) then
			c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
			c:RegisterFlagEffect(m+2,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
		end
	end
end
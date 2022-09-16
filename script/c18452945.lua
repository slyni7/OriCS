--하이엔젤 - 제니 더 포스
local m=18452945
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.pfil1,cm.pfun1,3,3)
	local e1=MakeEff(c,"FC","M")
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.tar1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","M")
	e2:SetCode(EVENT_CHAIN_SOLVING)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S")
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(9999)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"S")
	e4:SetCode(EFFECT_ATTACK_COST)
	e4:SetCost(cm.cost4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
function cm.pfil1(c,xc)
	return c:IsXyzLevel(xc,8)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={0x0,0x0,ATTRIBUTE_WATER,ATTRIBUTE_WATER,ATTRIBUTE_EARTH,ATTRIBUTE_EARTH,ATTRIBUTE_DARK,ATTRIBUTE_DARK}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
			and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	return true
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)>0 then
		return
	end
	if not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		return
	end
	if rp==tp then
		return
	end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g<1 then
		return
	end
	if g:IsContains(c) and Duel.IsChainDisablable(ev) then
		Duel.Hint(HINT_CARD,0,m)
		if Duel.NegateEffect(ev) then
			c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
			c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
		end
	end
end
function cm.cost4(e,c,tp)
	return e:GetHandler():GetAttackAnnouncedCount()<1 or (c:GetFlagEffect(m+1)<1 and c:CheckRemoveOverlayCard(tp,1,REASON_COST))
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetAttackAnnouncedCount()>0 then
		c:RemoveOverlayCard(tp,1,1,REASON_COST)
		c:RegisterFlagEffect(m+1,RESET_PHASE+PHASE_BATTLE+RESET_EVENT+0x1ec0000,0,1)
	end
end
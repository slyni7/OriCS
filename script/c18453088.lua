--사일런트 머조리티: 1만
local m=18453088
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,cm.pfil1,cm.pfil2)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e1:SetCountLimit(1)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
end
cm.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.pfil1(c,fc,sub,mg,sg)
	if c:IsFusionCode(18453076) or (sub and c:CheckFusionSubstitute(fc)) then
		if not sg or sg:FilterCount(aux.TRUE,c)<1 then
			return true
		end
		local g=sg:Clone()
		g:AddCard(c)
		local st=fc.square_mana
		return aux.IsFitSquare(g,st)
	end
	return false
end
function cm.pfil2(c,fc,sub,mg,sg)
	if c:IsFusionCode(18453078) or (sub and c:CheckFusionSubstitute(fc)) then
		if not sg or sg:FilterCount(aux.TRUE,c)<1 then
			return true
		end
		local g=sg:Clone()
		g:AddCard(c)
		local st=fc.square_mana
		return aux.IsFitSquare(g,st)
	end
	return false
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c==Duel.GetAttacker() and bc~=nil and bc:IsFaceup()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(m)<1
	end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() and not bc:IsImmuneToEffect(e) then
		local val=math.ceil(bc:GetAttack()/2)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(val)
		bc:RegisterEffect(e1)
		Duel.Recover(tp,val,REASON_EFFECT)
	end
end
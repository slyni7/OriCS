--사일런트 머조리티: 퀸틸리온
local m=18453097
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,cm.pfil1,cm.pfil2)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
cm.square_mana={ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_EARTH,ATTRIBUTE_EARTH,ATTRIBUTE_EARTH,ATTRIBUTE_EARTH}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.pfil1(c,fc,sub,mg,sg)
	if c:IsFusionCode(18453079) or (sub and c:CheckFusionSubstitute(fc)) then
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
	if c:IsFusionCode(18453083) or (sub and c:CheckFusionSubstitute(fc)) then
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
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYING) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsDestructable() then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
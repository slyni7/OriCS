--사일런트 머조리티: 10만
local m=18453089
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,cm.pfil1,cm.pfil2)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
end
cm.square_mana={ATTRIBUTE_WATER,ATTRIBUTE_WIND}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.pfil1(c,fc,sub,mg,sg)
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
function cm.pfil2(c,fc,sub,mg,sg)
	if c:IsFusionCode(18453075) or (sub and c:CheckFusionSubstitute(fc)) then
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
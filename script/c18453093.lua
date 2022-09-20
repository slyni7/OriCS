--사일런트 머조리티: 10억
local m=18453093
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,cm.pfil1,cm.pfil2,cm.pfil3)
	local e1=MakeEff(c,"FC","M")
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetTarget(cm.tar1)
	e1:SetValue(cm.val1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
cm.square_mana={ATTRIBUTE_WIND,ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.pfil1(c,fc,sub,mg,sg)
	if c:IsFusionCode(18453075) or (sub and c:CheckFusionSubstitute(fc)) then
		if not sg or sg:FilterCount(aux.TRUE,c)<2 then
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
	if c:IsFusionCode(18453079) or (sub and c:CheckFusionSubstitute(fc)) then
		if not sg or sg:FilterCount(aux.TRUE,c)<2 then
			return true
		end
		local g=sg:Clone()
		g:AddCard(c)
		local st=fc.square_mana
		return aux.IsFitSquare(g,st)
	end
	return false
end
function cm.pfil3(c,fc,sub,mg,sg)
	if c:IsFusionCode(18453078) or (sub and c:CheckFusionSubstitute(fc)) then
		if not sg or sg:FilterCount(aux.TRUE,c)<2 then
			return true
		end
		local g=sg:Clone()
		g:AddCard(c)
		local st=fc.square_mana
		return aux.IsFitSquare(g,st)
	end
	return false
end
function cm.tfil11(c,tp)
	return c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.tfil12(c,e,tp)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return eg:IsExists(cm.tfil11,1,nil,tp) and Duel.IEMCard(cm.tfil12,tp,"O",0,1,nil)
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SMCard(tp,cm.tfil12,tp,"O",0,1,1,nil)
		local tc=g:GetFirst()
		e:SetLabelObject(tc)
		tc:SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else
		return false
	end
end
function cm.val1(e,c)
	local tp=e:GetHandlerPlayer()
	return cm.tfil11(c,tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
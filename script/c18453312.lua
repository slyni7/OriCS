--사이비 교주 티아라로드
local m=18453312
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,m+EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetCL(1,m+1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()==0 then
			return false
		end
		e:SetLabel(0)
		return Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x2c4,0x11,700,2000,7,RACE_FAIRYT,ATTRIBUTE_DARK) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x2c4,0x11,700,2000,7,RACE_FAIRYT,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.tfil2(c)
	return c:IsCode(18453310) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil2,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,cm.tfil2,tp,"G",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		local off=1
		local ops={}
		local opval={}
		if Duel.IsPlayerCanDraw(tp,1) then
			ops[off]=aux.Stringid(m,1)
			opval[off-1]=1
			off=off+1
		end
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			Duel.Draw(tp,1,REASON_EFFECT)
			local e1=MakeEff(c,"FC")
			e1:SetCode(EFFECT_DESTROY_REPLACE)
			e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
			e1:SetCountLimit(1)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			e1:SetTarget(cm.otar21)
			e1:SetValue(cm.oval21)
			e1:SetOperation(cm.oop21)
			Duel.RegisterEffect(e1,tp)
		elseif opval[op]==2 then
			local e2=MakeEff(c,"F")
			e2:SetCode(EFFECT_HATOTAURUS_TOKEN)
			e2:SetReset(RESET_PHASE+PHASE_END,2)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTR(1,0)
			e2:SetOperation(cm.oop22)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.ovfil21(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_TOKEN) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.otfil21(c)
	return c:IsCode(18453309) and c:IsAbleToGrave()
end
function cm.otar21(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return eg:IsExists(cm.ovfil21,1,nil,tp)
			and Duel.IEMCard(cm.otfil21,tp,"D",0,1,nil)
	end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.oval21(e,c)
	local tp=e:GetHandlerPlayer()
	return cm.ovfil21(c,tp)
end
function cm.oop21(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.otfil21,tp,"D",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function cm.oop22(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_ORDER_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_MODULE_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SQUARE_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_BEYOND_MATERIAL)
	c:RegisterEffect(e7)
	local e8=e1:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_DELIGHT_MATERIAL)
	c:RegisterEffect(e8)
	local e9=e1:Clone()
	e9:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e9)
	local ea=MakeEff(c,"S")
	ea:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	ea:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(ea)
end

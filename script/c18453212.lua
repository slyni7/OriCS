--인투 디 언논 타임
local m=18453212
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetCL(1,m+YuL.O)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"E")
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","SG")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
end
function cm.tfil1(c,tp)
	return c:IsSetCard(0x2e7) and c:IsType(TYPE_MONSTER) and c:IsFacedown() and Duel.IsPlayerCanSpecialSummon(tp)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil1,tp,LSTN("R"),0,1,nil,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"R")
	Duel.SOI(0,CATEGORY_EQUIP,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tfil1,tp,LSTN("R"),0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
		Duel.Equip(tp,c,tc)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.oval11)
		e1:SetLabelObject(tc)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function cm.oval11(e,c)
	return e:GetLabelObject()==c
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost(POS_FACEDOWN)
	end
	Duel.Reomve(c,POS_FACEDOWN,REASON_COST)
end
function cm.tfil4(c)
	return c:IsSetCard(0x2e7) and c:IsCustomType(CUSTOMTYPE_DELIGHT) and c:IsFaceup()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("M") and cm.tfil4(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil4,tp,"M",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.STarget(tp,cm.tfil4,tp,"M",0,1,1,nil)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=MakeEff(c,"FC")
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCode(EVENT_BATTLE_START)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCL(1)
		e1:SetOperation(cm.oop41)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.oop41(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	if tc:IsRelateToBattle() and tc:GetFlagEffectLabel(m)==fid then
		Duel.Hint(HINT_CARD,0,m)
		local bc=tc:GetBattleTarget()
		if bc then
			Duel.Remove(bc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
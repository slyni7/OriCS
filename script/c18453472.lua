--투명하지만 분명히 있는
local m=18453472
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetCL(1,m+EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STf")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
function cm.tfil1(c)
	return c:IsSetCard("스플릿") and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil) and Duel.GetLocCount(tp,"S")>0
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"S")>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LSTN("S"),POS_FACEUP,true)
		end
	end
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		e1:SetLabel(Duel.GetTurnCount())
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		e1:SetLabel(0)
	end
	e1:SetCL(1)
	e1:SetCondition(cm.ocon11)
	e1:SetOperation(cm.oop11)
	Duel.RegisterEffect(e1,tp)
end
function cm.onfil11(c,e,tp)
	return c:IsCode(18453469) and (c:IsAbleToHand() or (Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.ocon11(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(cm.onfil11,tp,"D",0,1,nil,e,tp)
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.onfil11,tp,"D",0,0,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local th=tc:IsAbleToHand()
		local sp=Duel.GetLocCount(tp,"M")>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		local op=0
		if th and sp then
			op=Duel.SelectOption(tp,1190,1152)
		elseif th then
			op=0
		else
			op=1
		end
		if op==0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LSTN("HD"))
end
function cm.tfil2(c)
	return c:IsSetCard("스플릿") and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil2(chkc)
	end
	if chk==0 then
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.STarget(tp,cm.tfil2,tp,"G",0,1,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.GetLocCount(tp,"S")>0 then
		Duel.MoveToField(tc,tp,tp,LSTN("S"),POS_FACEUP,true)
	end
end
--연금생물학의 목표
local m=18452954
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SEARCH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(aux.TargetBoolFunction(Card.IsSetCard,"연금생물"))
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"E")
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","G")
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCost(aux.bfgcost)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
end
function cm.tfil1(c)
	return c:IsFaceup() and c:IsSetCard("연금생물")
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and cm.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil1,tp,"M","M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.STarget(tp,cm.tfil1,tp,"M","M",1,1,nil)
	Duel.SOI(0,CATEGORY_EQUIP,c,1,0,0)
end
function cm.ofil1(c)
	return c:IsSetCard("연금생물") and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.ofil1,tp,"D",0,0,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.Equip(tp,c,tc)
		end
	end
end
function cm.val3(e,c)
	local att=0
	if c:IsAttribute(ATTRIBUTE_FIRE) then
		att=att+ATTRIBUTE_WATER
	end
	if c:IsAttribute(ATTRIBUTE_WATER) then
		att=att+ATTRIBUTE_FIRE
	end
	if c:IsAttribute(ATTRIBUTE_LIGHT) then
		att=att+ATTRIBUTE_DARK
	end
	if c:IsAttribute(ATTRIBUTE_DARK) then
		att=att+ATTRIBUTE_LIGHT
	end
	if c:IsAttribute(ATTRIBUTE_WIND) then
		att=att+ATTRIBUTE_EARTH
	end
	if c:IsAttribute(ATTRIBUTE_EARTH) then
		att=att+ATTRIBUTE_WIND
	end
	return att
end
function cm.tfil4(c,e,tp)
	return c:IsCode(40410110) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil4(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil4,tp,"G",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil4,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)	
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR("M",0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,"연금생물"))
	e1:SetValue(cm.oval41)
	Duel.RegisterEffect(e1,tp)
end
function cm.oval41(e,c,rc)
	if rc:IsCustomType(CUSTOMTYPE_SQUARE) then
		return 0x80000+c:GetLevel()
	end
	return c:GetLevel()
end
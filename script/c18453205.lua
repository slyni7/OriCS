--샤이닝 글로리
local m=18453205
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","G")
	e2:SetCode(EVENT_BE_CUSTOM_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1,m+1)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
function cm.nfil1(c)
	return c:IsFacedown() or not c:IsRace(RACE_FAIRY)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(cm.nfil1,tp,"M",0,1,nil)
end
function cm.tfil1(c)
	return ((c:IsSetCard(0x2e7) and c:IsType(TYPE_MONSTER) and not c:IsCode(m)) or (c:IsSetCard(0x2e8) and c:IsType(TYPE_SPELL+TYPE_TRAP)))
		and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c) and r==CUSTOMREASON_DELIGHT and c:IsPreviousLocation(LSTN("O"))
end
function cm.tfil2(c,tp)
	return c:IsControler(tp) and c:IsLoc("R") and c:IsFacedown() and Duel.IsPlayerCanSpecialSummon(tp)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return eg:IsExists(cm.tfil2,1,nil,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SetTargetCard(eg)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"R")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	local g=eg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:FilterSelect(tp,cm.tfil2,1,1,nil,tp)
	local tc=sg:GetFirst()
	if tc and Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP_DEFENSE)>0 and tc:IsLoc("M") then
		local e1=MakeEff(c,"F","M")
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetTarget(cm.otar21)
		tc:RegisterEffect(e1,true)
	end
end
function cm.otar21(e,c)
	return not c:IsCustomType(CUSTOMTYPE_DELIGHT) and c:IsLocation(LOCATION_EXTRA)
end
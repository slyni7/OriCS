--모닝 글로리
local m=18452746
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddDelightProcedure(c,cm.pfil1,2,2)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","MG")
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
cm.custom_type=CUSTOMTYPE_DELIGHT
function cm.pfil1(c)
	return c:IsLoc("G")
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_DELIGHT)
end
function cm.tfil1(c,tp)
	return c:IsSetCard(0x2e7) and c:IsType(TYPE_MONSTER) and c:IsFacedown() and not c:IsCode(m)
		and (c:IsAbleToHand() or (Duel.IsPlayerCanSpecialSummon(tp) and Duel.GetLocCount(tp,"M")>0))
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil1,tp,LSTN("R"),0,1,nil,tp)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,0,tp,"R")
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,"R")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tfil1,tp,LSTN("R"),0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not Duel.IsPlayerCanSpecialSummon(tp) or Duel.GetLocCount(tp,"M")<1
			or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==0) then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		end
	end
end
function cm.tfil2(c)
	return c:IsCustomType(CUSTOMTYPE_DELIGHT) and c:IsDelightSummonable(nil)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local e1=MakeEff(c,"F",c:GetLocation())
		e1:SetCode(EFFECT_MUST_BE_DEL_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_CHAIN)
		c:RegisterEffect(e1)
		local res=Duel.IEMCard(cm.tfil2,tp,"E",0,1,nil)
		e1:Reset()
		return res
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,"E")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and (c:IsFaceup() or c:IsLoc("G")) then
		local e1=MakeEff(c,"F",c:GetLocation())
		e1:SetCode(EFFECT_MUST_BE_DEL_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_CHAIN)
		c:RegisterEffect(e1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,cm.tfil2,tp,"E",0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.DelightSummon(tp,tc,nil)
		end
		e1:Reset()
	end
end
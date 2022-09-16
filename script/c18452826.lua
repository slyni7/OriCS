--스퀘어크루 싱커
local m=18452826
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.pfil1,nil,nil,aux.NonTuner(nil),1,99,cm.pfun1)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,m+1)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
function cm.pfil1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsCustomType(CUSTOMTYPE_SQUARE)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={ATTRIBUTE_FIRE,0x0,0x0,0x0,ATTRIBUTE_WIND}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.tfil1(c)
	return c:IsSetCard(0x2d8) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LSTN("M")) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.tfil2(c,e,tp)
	return c:IsSetCard(0x2d7) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(cm.tfil2,tp,"DG",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"DG")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"DG",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
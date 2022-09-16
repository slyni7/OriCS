--물의 연금생물학자 라이카
local m=18452942
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"I","M")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","M")
	e2:SetCode(EVENT_ATTRIBUTE_CHANGE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCountLimit(1,m+1)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	aux.RegisterAttributeEvent(c)
end
cm.square_mana={ATTRIBUTE_EARTH,0x0,0x0,ATTRIBUTE_WIND}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.con1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return not Duel.IEMCard(aux.TRUE,tp,"M",0,1,c)
end
function cm.tfil1(c,e,tp)
	return c:IsCode(40410110) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function cm.tfil2(c)
	return c:IsSetCard("연금생물") and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
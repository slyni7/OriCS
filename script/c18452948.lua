--은의 연금생물학자 리타
local m=18452948
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.pfil1,cm.pfun1,2,2)
	local e1=MakeEff(c,"I","M")
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","M")
	e3:SetCode(EVENT_ATTRIBUTE_CHANGE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCountLimit(1,m+1)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	aux.RegisterAttributeEvent(c)
end
function cm.pfil1(c,xc)
	return c:IsXyzLevel(xc,4)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={ATTRIBUTE_WIND,0x0,0x0,ATTRIBUTE_EARTH}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsFaceup,tp,"M","M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,Card.IsFaceup,tp,"M","M",1,1,nil)
	local tc=g:GetFirst()
	local tatt=tc:GetAttribute()
	local att=Duel.AnnounceAttribute(tp,1,0xfff-tatt)
	e:SetLabel(att)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local att=e:GetLabel()
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(att)
		tc:RegisterEffect(e1)
	end
end
function cm.tfil2(c,e,tp)
	return c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	if chk==0 then
		return og:IsExists(cm.tfil2,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"X")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocCount(tp,"M")<1 then
		return
	end
	local og=c:GetOverlayGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=og:FilterSelect(tp,cm.tfil2,1,1,nil,e,tp)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function cm.tfil3(c)
	return (c:IsRace(RACE_ALCHEMIST) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard("연금생물"))) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
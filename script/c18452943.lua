--공기의 연금생물학자 카나에
local m=18452943
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"FTo","H")
	e1:SetCode(EVENT_ATTRIBUTE_CHANGE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	aux.RegisterAttributeEvent(c)
end
cm.square_mana={ATTRIBUTE_FIRE,0x0,0x0,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1) and Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocCount(tp,"M")>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if Duel.Draw(tp,1,REASON_EFFECT)<1 then
			return
		end
		local og=Duel.GetOperatedGroup()
		local dc=og:GetFirst()
		if dc:IsSetCard("연금생물") and dc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0
			and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(dc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
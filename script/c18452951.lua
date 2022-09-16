--연금생물실험
local m=18452951
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","G")
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCondition(aux.exccon)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.tfil1(c,e,tp)
	return c:IsSetCard("연금생물") and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand()
		or (c:IsCode(40410110) and Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,0,tp,"D")
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand()
			and (not tc:IsCode(40410110) or Duel.GetLocCount(tp,"M")<1
				or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.cfil2(c)
	return c:IsFaceup() and c:GetAttribute()~=c:GetOriginalAttribute()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost() and Duel.IEMCard(cm.cfil2,tp,"M",0,1,nil)
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.cfil2,tp,"M",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
end
--smilegirl(미소미소녀) C
local m=18453342
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCL(1)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","M")
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetCL(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function cm.val1(e,re,r,rp)
	return r&(REASON_BATTLE+REASON_EFFECT)>0
end
function cm.tfil2(c,e,tp)
	if not c:IsCode(18453340) then
		return false
	end
	if c:IsLoc("O") then
		return c:IsFaceup() and Duel.IsPlayerCanDraw(tp,1)
	elseif c:IsLoc("H") then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	elseif c:IsLoc("DG") then
		return c:IsAbleToHand()
	end
	return false
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"OHDG",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,"H")
	Duel.SOI(0,CATEGORY_TOHAND,nil,0,tp,"DG")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"OHDG",0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if tc:IsLoc("O") then
			Duel.HintSelection(g)
			if Duel.Draw(tp,1,REASON_EFFECT)>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local sg=Duel.SMCard(tp,Card.IsAbleToDeck,tp,"H",0,1,1,nil)
				if #sg>0 then
					Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
				end
			end
		elseif tc:IsLoc("H") then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		elseif tc:IsLoc("DG") then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
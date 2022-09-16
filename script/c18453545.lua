--용암환락
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","S")
	e2:SetCategory(CATEGORY_SUMMON)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","G")
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
function s.ofil11(c)
	return c:IsCode(18453527) and c:IsAbleToHand()
end
function s.ofil12(c)
	return c:IsCode(18453527) and c:IsFaceup()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g1=Duel.GMGroup(s.ofil11,tp,"D",0,nil)
		local b1=#g1>0
		local b2=Duel.IEMCard(s.ofil12,tp,"O",0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
		if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
				Duel.Draw(tp,1,REASON_EFFECT)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g1:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.tfil2(c)
	return c:IsCode(18453527) and c:IsSummonable(true,nil)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"HM",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SMCard(tp,s.tfil2,tp,"HM",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function s.tfil31(c,e)
	return c:IsCanBeEffectTarget(e) and c:IsType(TYPE_NORMAL) and c:IsRace(RACE_WYRM)
end
function s.tfil32(c)
	return c:IsAbleToHand()
end
function s.tfil33(c)
	return c:IsAbleToDeck()
end
function s.tfun3(g)
	local fc=g:GetFirst()
	local nc=g:GetNext()
	return (s.tfil32(fc) and s.tfil33(nc)) or (s.tfil33(fc) and s.tfil32(nc))
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(s.tfil31,tp,"G",0,nil,e)
	if chk==0 then
		return g:CheckSubGroup(s.tfun3,2,2)
	end
	Duel.SOI(0,CATEGORY_TOHAND,sg,1,0,0)
	Duel.SOI(0,CATEGORY_TODECK,sg,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:FilterSelect(tp,s.tfil32,1,1,nil)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		g:Sub(sg)
		if #g>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
--흑염룡 각성의 전율
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function s.tfil11(c)
	return c:IsCode(18453527) and c:IsAbleToHand()
end
function s.tfil12(c)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_WYRM) and c:IsAbleToHand()
end
function s.tfun1(g)
	local fc=g:GetFirst()
	local nc=g:GetNext()
	return (s.tfil11(fc) and s.tfil12(nc)) or (s.tfil12(fc) and s.tfil11(nc))
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(aux.OR(s.tfil11,s.tfil12),tp,"DG",0,nil)
	if chk==0 then
		return g:CheckSubGroup(s.tfun1,2,2)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,2,tp,"DG")
	Duel.SOI(0,CATEGORY_TODECK,nil,1,tp,"H")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(aux.OR(s.tfil11,s.tfil12),tp,"DG",0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,s.tfun1,false,2,2)
	if #sg==2 and Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		local dg=Duel.SMCard(tp,Card.IsAbleToDeck,tp,"H",0,1,1,nil)
		if #dg>0 then
			Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
		end
	end
end
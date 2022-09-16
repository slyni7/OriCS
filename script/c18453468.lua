--더미머미 ~이그드라실~
local m=18453468
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STf")
	e2:SetCode(EVENT_MOVE)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_SUMMON)
	WriteEff(e2,2,"NO")
	c:RegisterEffect(e2)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLoc("F")
end
function cm.ofil21(c)
	return c:IsSetCard("더미머미") and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.ofil22(c)
	return c:IsSetCard("더미머미") and c:IsSummonable(true,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IEMCard(cm.ofil21,tp,"D",0,1,nil)
	local b2=Duel.IEMCard(cm.ofil22,tp,"H",0,1,nil)
	if not b1 and not b2 then
		return
	end
	local op=aux.SelectEffect(tp,{b1,aux.Stringid(m,0)},{b2,aux.Stringid(m,1)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.ofil21,tp,"D",0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,cm.ofil22,tp,"H",0,1,1,nil)
		local tc=g:GetFirst()
		Duel.Summon(tp,tc,true,nil)
	end
end
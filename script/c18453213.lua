--인투 디 언논 윈터
local m=18453213
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetCL(1,m+YuL.O)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","G")
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCL(1,m+1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.ocon11)
	e1:SetOperation(cm.oop11)
	Duel.RegisterEffect(e1,tp)
end
function cm.onfil11(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_DELIGHT) and c:IsCustomType(CUSTOMTYPE_DELIGHT)
		and c:IsLoc("M")
end
function cm.onfil12(c)
	return c:IsSetCard(0x2e7) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.onfil13(c)
	return c:IsSetCard(0x2e8) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.ocon11(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.onfil11,1,nil,tp) and Duel.IEMCard(cm.onfil12,tp,"D",0,1,nil) and Duel.IEMCard(cm.onfil13,tp,"D",0,1,nil)
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IEMCard(cm.onfil12,tp,"D",0,1,nil) and Duel.IEMCard(cm.onfil13,tp,"D",0,1,nil) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SMCard(tp,cm.onfil12,tp,"D",0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SMCard(tp,cm.onfil13,tp,"D",0,1,1,nil)
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		e:Reset()
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsDiscardable,tp,"H",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,Card.IsDiscardable,tp,"H",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SOI(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
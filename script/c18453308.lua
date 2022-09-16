--폴라 익스체인지
local m=18453308
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
cm.delightsworn=true
function cm.cfil1(c)
	return c:IsSetCard(0x2ed) and c:IsSetCard(0x38) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil1,tp,"H",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,cm.cfil1,tp,"H",0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g4=Duel.GetDecktopGroup(tp,4)
	local g2=Duel.GetDecktopGroup(tp,2)
	g4:Sub(g2)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
			and g4:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==2
			and Duel.GetFieldGroupCount(tp,LSTN("D"),0)>3
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SOI(0,CATEGORY_REMOVE,nil,2,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Draw(tp,2,REASON_EFFECT)
	Duel.BreakEffect()
	local g2=Duel.GetDecktopGroup(tp,2)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end

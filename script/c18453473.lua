--확률마저도 넘어서는 가능성
local m=18453473
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_TO_DECK)
	WriteEff(e1,1,"NO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_TO_HAND)
	WriteEff(e2,2,"N")
	WriteEff(e2,1,"O")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTf","S")
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetD(m,0)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FTf","S")
	e4:SetCode(EVENT_TO_HAND)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetD(m,1)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
end
function cm.nfil1(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LSTN("H"))
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil1,1,nil,tp)
end
function cm.ofil1(c)
	return c:IsSetCard("스플릿") and c:IsSSetable() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if Duel.GetLocCount(tp,"S")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,cm.ofil1,tp,"D",0,0,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		Duel.SSet(tp,tc)
	end
end
function cm.nfil2(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LSTN("D"))
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil2,1,nil,tp)
end
function cm.nfil3(c)
	return c:IsSetCard("스플릿") and c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and not c:IsCode(m)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(cm.nfil3,tp,"O",0,1,nil) and eg:IsExists(cm.nfil1,1,nil,tp)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=eg:FilterCount(cm.nfil1,nil,tp)
		e:SetLabel(ct)
		return true
	end
	local ct=e:GetLabel()
	Duel.SOI(0,CATEGORY_TODECK,nil,ct,1-tp,"H")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if not Duel.IEMCard(cm.nfil3,tp,"O",0,1,nil) then
		return
	end
	local g=Duel.GMGroup(Card.IsAbleToDeck,tp,0,"H",nil)
	local ct=e:GetLabel()
	if ct>#g then
		ct=#g
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(1-tp,ct,ct,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(cm.nfil3,tp,"O",0,1,nil) and eg:IsExists(cm.nfil2,1,nil,tp)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=eg:FilterCount(cm.nfil2,nil,tp)
		e:SetLabel(ct)
		return true
	end
	local ct=e:GetLabel()
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if not Duel.IEMCard(cm.nfil3,tp,"O",0,1,nil) then
		return
	end
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
end
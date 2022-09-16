--smilegirl(미소미소녀) XYZ
local m=18453351
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,18453348,18453349,18453350,true,true)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsDiscardable,tp,"H",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,Card.IsDiscardable,tp,"H",0,1,1,nil)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetCode())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField()
	end
	if chk==0 then
		return Duel.IETarget(aux.TRUE,tp,"O","O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,aux.TRUE,tp,"O","O",1,1,nil)
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
	local code=e:GetLabel()
	if code==18453348 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	elseif code==18453349 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	elseif code==18453350 then
		e:SetCategory(CATEGORY_DESTROY)
	else
		e:SetCategory(CATEGORY_DESTROY)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.Destroy(tc,REASON_EFFECT)==0 then
		return
	end
	local code=e:GetLabel()
	local g=Duel.GMGroup(Card.IsAbleToGrave,tp,"O","O",nil)
	if code==18453348 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	elseif code==18453349 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif code==18453350 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTR("O","O")
		e1:SetTarget(cm.otar11)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=MakeEff(c,"FC")
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(cm.ocon12)
		e2:SetOperation(cm.oop12)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=MakeEff(c,"F")
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTR("M","M")
		e3:SetTarget(cm.otar11)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function cm.otar11(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.ocon12(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
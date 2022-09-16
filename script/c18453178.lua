--줄라이 데미
local m=18453178
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
function cm.cfil1(c)
	return c:IsSetCard(0x2e5) and c:IsDiscardable()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil1,tp,"H",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,cm.cfil1,tp,"H",0,1,1,nil)
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
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local g=og:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	if chk==0 then
		return c:IsReleasable() and #g>0 and Duel.GetMZoneCount(tp,c,tp)>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	if c:IsRelateToEffect(e) then
		Duel.Release(c,REASON_EFFECT)
		local ft=Duel.GetLocCount(tp,"M")
		if ft<1 then
			return
		end
		local g=og:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
		if #g>ft then
			g=g:Select(tp,ft,ft,nil)
		end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
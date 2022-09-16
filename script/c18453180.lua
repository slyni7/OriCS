--줄라이 큐리
local m=18453180
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and chkc:IsAttackPos()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsAttackPos,tp,"M","M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,Card.IsAttackPos,tp,"M","M",1,1,nil)
	Duel.SOI(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
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
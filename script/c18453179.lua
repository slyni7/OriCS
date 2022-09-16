--줄라이 유미
local m=18453179
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"F","M")
	e1:SetTR("M","M")
	e1:SetValue(POS_FACEUP_DEFENSE)
	e1:SetTarget(cm.tar1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
function cm.tar1(e,c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonLocation()&LSTN("E")>0
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
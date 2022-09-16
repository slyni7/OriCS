--줄라이 카리엘
local m=18453176
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_POSITION)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and rp~=tp
end
function cm.cfil1(c)
	return c:IsSetCard(0x2e5) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckReleaseGroupEx(tp,cm.cfil1,1,nil)
	end
	local g=Duel.SelectReleaseGroupEx(tp,cm.cfil1,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1) and c:IsAttackPos() and c:IsCanChangePosition()
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsDestructable() then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	if c:IsRelateToEffect(e) then
		Duel.SOI(0,CATEGORY_POSITION,c,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
			Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
		end
	end
	Duel.Draw(tp,1,REASON_EFFECT)
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
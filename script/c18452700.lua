--이브닝 글로리
local m=18452700
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddDelightProcedure(c,aux.FBF(Card.IsType,TYPE_EFFECT),2,2)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","G")
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
cm.custom_type=CUSTOMTYPE_DELIGHT
function cm.nfil1(c,g)
	return c:IsOnField() and g:IsContains(c)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return false
	end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return false
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return g and ex and tg and g:IsExists(cm.nfil1,1,nil,tg) and Duel.IsChainNegatable(ev)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
	c:CreateEffectRelation(e)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsDestructable() then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) then
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,2,Duel.GetTurnCount())
		else
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,1)
		end
	end
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:GetFlagEffect(m)>0 and c:GetFlagEffectLabel(m)~=Duel.GetTurnCount()
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--사운드 오브 워킹 어웨이
local m=18453456
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","HM")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetD(m,0)
	e1:SetCL(1,m)
	WriteEff(e1,1,"CO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetCL(1,m)
	WriteEff(e2,2,"C")
	WriteEff(e2,1,"O")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_CONTROL)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable() and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
	end
	Duel.Release(c,REASON_COST)
	local e1=MakeEff(c,"F")
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_EXTRA_RELEASE_SUM)
	e1:SetTR(0,"M")
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost() and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	local e1=MakeEff(c,"F")
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 and c:GetAttackAnnouncedCount()==0
	end
	local e1=MakeEff(c,"F")
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsControlerCanBeChanged,tp,0,"M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.STarget(tp,Card.IsControlerCanBeChanged,tp,0,"M",1,1,nil)
	Duel.SOI(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
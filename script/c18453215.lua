--인투 디 언논 엔딩
local m=18453215
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetCL(1,m+YuL.O)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCL(1,m+1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_BE_CUSTOM_MATERIAL)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	if r~=CUSTOMREASON_DELIGHT then
		return
	end
	local tc=eg:GetFirst()
	while tc do
		local rc=tc:GetReasonCard()
		if tc:IsPreviousLocation(LSTN("G")) then
			rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,0)
		end
		tc=eg:GetNext()
	end
end
function cm.nfil1(c)
	return c:IsFaceup() and c:IsCustomType(CUSTOMTYPE_DELIGHT) and c:IsSetCard(0x2e7)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(cm.nfil1,tp,"M",0,1,nil) and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
		and Duel.IsChainNegatable(ev) and rp~=tp
end
function cm.tfil1(c)
	return c:IsFaceup() and c:IsCustomType(CUSTOMTYPE_DELIGHT) and c:IsSetCard(0x2e7) and c:GetFlagEffect(m)>0
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	local b=Duel.IEMCard(cm.tfil1,tp,"M",0,1,nil)
	if b then
		e:SetLabel(10000)
	else
		e:SetLabel(0)
	end
	if rc:IsDestructable() and rc:IsRelateToEffect(re) and (not b or not rc:IsAbleToRemove(POS_FACEDOWN)) then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	elseif rc:IsRelateToEffect(re) and b and rc:IsAbleToRemove(POS_FACEDOWN) then
		Duel.SOI(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		if rc:IsDestructable() and (e:GetLabel()==0 or not rc:IsAbleToRemove(POS_FACEDOWN)) then
			Duel.Destroy(eg,REASON_EFFECT)
		elseif e:GetLabel()==10000 and rc:IsAbleToRemove(POS_FACEDOWN) then
			Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost(POS_FACEDOWN)
	end
	Duel.Remove(c,POS_FACEDOWN,REASON_COST)
end
function cm.tfil2(c)
	return c:IsSetCard(0x2e7) and c:IsType(TYPE_MONSTER) and c:IsFacedown() and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil2,tp,LSTN("R"),0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"R")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tfil2,tp,LSTN("R"),0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
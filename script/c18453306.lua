--딜라이트로드 청설모 스노우블루
local m=18453306
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_REMOVE)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","R")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
end
cm.delightsworn=true
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		return Duel.IETarget(Card.IsAbleToRemove,tp,0,"M",1,nil,tp,POS_FACEDOWN)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.STarget(tp,Card.IsAbleToRemove,tp,0,"M",1,1,nil,tp,POS_FACEDOWN)
	Duel.SOI(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local e1=MakeEff(c,"FC")
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.oop11)
		e1:SetLabel(1)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetLabel()
	if t==1 then
		e:SetLabel(0)
	else
		Duel.ReturnToField(e:GetLabelObject())
	end
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFacedown()
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocCount(tp,"M")
	local ct=-ft+1
	local sg=Duel.GMGroup(Card.IsAbleToRemoveAsCost,tp,"HOG",0,c,POS_FACEDOWN)
	if chk==0 then
			return #sg>6 and (ft>0 or sg:IsExists(Card.IsLoc,ct,nil,"M"))
	end
	local g=nil
	if ft<1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=sg:FilterSelect(tp,Card.IsLoc,ct,ct,nil,"M")
		if ct<7 then
			sg:Sub(g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g1=sg:Select(tp,7-ct,7-ct,nil)
			g:Merge(g1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=sg:Select(tp,7,7,nil)
	end
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsPlayerCanSpecialSummon(tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--딜라이트로드 클로저 이로하스
local m=18453305
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"I","M")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e4=MakeEff(c,"FTf","M")
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetCL(1)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
end
cm.delightsworn=true
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsAbleToRemoveAsCost,tp,"H",0,1,nil,POS_FACEDOWN)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,Card.IsAbleToRemoveAsCost,tp,"H",0,1,1,nil,POS_FACEDOWN)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.tfil1(c,e,tp)
	if not (c:IsSetCard(0x2ed) and c:IsSetCard(0x38) and c:IsLevelBelow(4)) then
		return false
	end
	if c:IsLoc("R") and c:IsFacedown() then
		return Duel.IsPlayerCanSpecialSummon(tp)
	end
	if c:IsLoc("D") then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	return false
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil1,tp,LSTN("DR"),0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"DR")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tfil1,tp,LSTN("DR"),0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_REMOVE,nil,2,tp,"D")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GetDecktopGroup(tp,2)
	if #g>0 then
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end

--딜라이트로드 나이트 아포칼립스
local m=18453302
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOGRAVE)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FTf","M")
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetCL(1)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
end
cm.delightsworn=true
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsAbleToGrave,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,Card.IsAbleToGrave,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
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

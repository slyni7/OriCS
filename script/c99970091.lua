--[ [ Matryoshka ] ]
local m=99970091
local cm=_G["c"..m]
function cm.initial_effect(c)

	--마트료시카
	YuL.MatryoshkaProcedure(c,cm.MatryoshkaMaterial,nil,0)
	YuL.MatryoshkaOpen(c,nil)
	
	--엑스트라 덱 파괴
	local e1=MakeEff(c,"STo")
	e1:SetD(m,0)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--파괴 대행
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.reptg)
	c:RegisterEffect(e2)

end

--마트료시카
function cm.MatryoshkaMaterial(c)
	return c:IsSetCard(0xd37) and c:IsFaceup() and c:GetOverlayCount()>1
end

--엑스트라 덱 파괴
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	if #tg==0 then return end
	local ct=e:GetHandler():GetOverlayCount()+1
	Duel.ConfirmCards(tp,tg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=tg:Select(tp,1,ct,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.ShuffleExtra(1-tp)
	end
end

--파괴 대행
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and #g>0 end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		return true
	else return false end
end

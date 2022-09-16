--[ [ Matryoshka ] ]
local m=99970088
local cm=_G["c"..m]
function cm.initial_effect(c)

	--마트료시카
	YuL.MatryoshkaProcedure(c,nil,nil,0)
	YuL.MatryoshkaOpen(c,nil)

	--마함 파괴
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(m,0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetCL(1)
	e1:SetCost(spinel.rmovcost(1))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--파괴 대행
	local e2=MakeEff(c,"FC","H")
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(cm.tar2)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	
end

--마함 파괴
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsType(YuL.ST) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,YuL.ST) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil,YuL.ST)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	Duel.Destroy(g,REASON_EFFECT)
end

--파괴 대행
function cm.tar2fil(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xd37) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) 
		and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  end
	local g=eg:Filter(cm.tar2fil,nil,tp)
	if chk==0 then return #g>0 end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_CARD,1-tp,m)
		local sg=g:Select(tp,1,1,nil)
		Duel.Overlay(sg:GetFirst(),Group.FromCards(e:GetHandler()))
		return true
	else return false end
end
function cm.val2(e,c)
	return cm.tar2fil(c,e:GetHandlerPlayer())
end

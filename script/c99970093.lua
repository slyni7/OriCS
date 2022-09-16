--[ [ Matryoshka ] ]
local m=99970093
local cm=_G["c"..m]
function cm.initial_effect(c)

	--융합 소환
	RevLim(c)
	aux.AddFusionProcFun2(c,aux.FBF(Card.IsFusionSetCard,0xd37),cm.Ffil,true)
	
	--마트료시카
	YuL.MatryoshkaProcedure(c,cm.MatryoshkaMaterial,nil,SUMT_F)
	YuL.MatryoshkaOpen(c,m)
	
	--회수
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1)
	e1:SetCost(spinel.rmovcost(1))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--소재 보충
	local e2=MakeEff(c,"FTo","M")
	e2:SetD(m,1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCL(1)
	e2:SetCondition(YuL.turn(0))
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
end

--융합 소환
function cm.Ffil(c)
	return c:GetOverlayCount()>0
end

--마트료시카
function cm.MatryoshkaMaterial(c)
	return c:IsSetCard(0xd37) and c:IsFaceup() and c:GetOriginalLevel()>=5
end

--회수
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end

--소재 보충
function cm.tar2fil(c)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_MZONE)) or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0xd37)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.tar2fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar2fil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.tar2fil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.tar2fil,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(cm.tar2fil,tp,LOCATION_GRAVE,0,nil)
	if #g>0 and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local sg=g:Select(tp,1,1,nil)
		Duel.Overlay(tc,sg)
	end
end

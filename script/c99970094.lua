--[ [ Matryoshka ] ]
local m=99970094
local cm=_G["c"..m]
function cm.initial_effect(c)

	--싱크로 소환
	RevLim(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xd37),1)
	
	--마트료시카
	YuL.MatryoshkaProcedure(c,cm.MatryoshkaMaterial,nil,SUMT_S)
	YuL.MatryoshkaOpen(c,m)
	
	--파괴 / 소재 흡수
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCL(1)
	e1:SetCost(spinel.rmovcost(1))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--자가 소생
	local e2=MakeEff(c,"STo")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
end

--마트료시카
function cm.MatryoshkaMaterial(c)
	return c:IsSetCard(0xd37) and c:IsFaceup() and c:GetOriginalLevel()>=5
end

--파괴 / 소재 흡수
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function cm.op1fil(c,tp)
	return not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		if Duel.Destroy(g,REASON_EFFECT)~=2 then
			local g2=Duel.GetMatchingGroup(cm.op1fil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,tp)
			if #g2>0 and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect()
				local sg=g2:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				local og=sg:GetFirst():GetOverlayGroup()
				if #og>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				Duel.Overlay(c,sg)
			end
		end
	end
end

--자가 소생
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

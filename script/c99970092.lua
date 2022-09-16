--[ [ Matryoshka ] ]
local m=99970092
local cm=_G["c"..m]
function cm.initial_effect(c)

	--링크 소환
	RevLim(c)
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	
	--마트료시카
	YuL.MatryoshkaProcedure(c,cm.MatryoshkaMaterial,nil,SUMT_L)
	YuL.MatryoshkaOpen(c,m)
	
	--소재 흡수
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(m,0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--대상 내성 부여
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd37))
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)

end

--링크 소환
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xd37)
end

--마트료시카
function cm.MatryoshkaMaterial(c)
	return c:IsSetCard(0xd37) and c:IsFaceup() and c:GetOriginalLevel()>=5
end

--소재 흡수
function cm.tar1fil(c,g,tp)
	return not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler()) and g:IsContains(c)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tar1fil(chkc,lg,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar1fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.tar1fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lg,tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if #og>0 then
			Duel.Overlay(c,og)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end

--[ Lava Golem ]
local m=99970718
local cm=_G["c"..m]
function cm.initial_effect(c)

	--각인 + 덤핑
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
end

--각인 + 덤핑
function cm.tar1fil(c)
	return c:IsLavaGolemCard() and c:IsAbleToGrave()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar1fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.op1fil(c)
	return c:GetControler()~=c:GetOwner() and c:IsLavaGolemCard() and c:IsFaceup()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(cm.tar1fil,tp,LOCATION_DECK,0,nil)
	if #dg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=dg:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE):Filter(cm.op1fil,nil)
	if #g>0 then
		Duel.BreakEffect()
		for tc in aux.Next(g) do
			if not tc:IsImmuneToEffect(e) then
				tc:ResetEffect(EFFECT_SET_CONTROL,RESET_CODE)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_CONTROL)
				e1:SetValue(tc:GetOwner())
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-(RESET_TOFIELD+RESET_TEMP_REMOVE+RESET_TURN_SET))
				tc:RegisterEffect(e1)
			end
		end
	end
end

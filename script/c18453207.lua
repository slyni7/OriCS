--비기닝 글로리
local m=18453207
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_BE_CUSTOM_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCL(1,m+1)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil1(c)
	return c:IsCode(18453210) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLoc("G") and r==CUSTOMREASON_DELIGHT and c:IsPreviousLocation(LSTN("O"))
end
function cm.tfil2(c)
	return ((c:IsSetCard(0x2e7) and c:IsType(TYPE_MONSTER) and not c:IsCode(m)) or (c:IsSetCard(0x2e8) and c:IsType(TYPE_SPELL+TYPE_TRAP)))
		and c:IsAbleToGrave()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(g,REASON_EFFECT)>0 and tc:IsLoc("G") then
		local e1=MakeEff(c,"F","G")
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetTarget(cm.otar21)
		tc:RegisterEffect(e1,true)
	end
end
function cm.otar21(e,c)
	return not c:IsCustomType(CUSTOMTYPE_DELIGHT) and c:IsLocation(LOCATION_EXTRA)
end
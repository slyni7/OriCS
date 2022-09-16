--버닝 글로리
local m=18452744
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddDelightProcedure(c,nil,2,2,cm.pfun1)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","M")
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
cm.custom_type=CUSTOMTYPE_DELIGHT
function cm.pffil1(c)
	return c:IsSetCard(0x2e7) and c:IsCustomType(CUSTOMTYPE_DELIGHT)
end
function cm.pfun1(g)
	return g:IsExists(cm.pffil1,1,nil)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and chkc:IsControler(1-tp)
	end
	if chk==0 then
		return Duel.IETarget(aux.TRUE,tp,0,"M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,aux.TRUE,tp,0,"M",1,1,nil)
	local tc=g:GetFirst()
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
	if tc:IsFaceup() then
		Duel.SOI(0,CATEGORY_DAMAGE,nil,0,1-tp,math.floor(tc:GetTextAttack()/2))
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,math.floor(tc:GetTextAttack()/2),REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(cm.oval11)
		c:RegisterEffect(e1)
	end
end
function cm.oval11(e,re,r,rp)
	return r&REASON_BATTLE+REASON_EFFECT>0
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("R") and chkc:IsControler(tp) and chkc:IsFacedown()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsFacedown,tp,"R",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.STarget(tp,Card.IsFacedown,tp,"R",0,1,1,nil)
end
function cm.ofil2(c)
	return c:IsSetCard(0x2e8) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)>0 and tc:IsLoc("G") then
		if tc:IsSetCard(0x2e7) and tc:IsType(TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
		local g=Duel.GMGroup(cm.ofil2,tp,"G",0,tc)
		if tc:IsSetCard(0x2e8) and tc:IsType(TYPE_SPELL+TYPE_TRAP) and #g>0
			and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
		if tc:IsCustomType(CUSTOMTYPE_DELIGHT) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
--찬란하게 빛나던 내 모습은
local m=18453210
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,m+YuL.O)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","F")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCL(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","F")
	e3:SetCode(EVENT_CHAIN_SOLVING)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsDiscardable,tp,"H",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,Card.IsDiscardable,tp,"H",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.tfil2(c)
	return c:IsSetCard(0x2e7) and c:IsType(TYPE_MONSTER) and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.ofil3(c,tp)
	return c:IsLoc("M") and c:IsControler(tp) and c:IsFaceup() and c:IsCustomType(CUSTOMTYPE_DELIGHT)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g<1 then
		return
	end
	local tg=g:Filter(cm.ofil3,nil,tp)
	if #tg>0 and c:IsAbleToGrave() and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local tc=tg:GetFirst()
		while tc do
			tc:ReleaseEffectRelation(re)
			tc=tg:GetNext()
		end
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
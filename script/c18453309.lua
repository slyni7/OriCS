--버츄얼 타짜 카사블랑카
local m=18453309
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","G")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
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
	return c:IsCode(18453311) and c:IsAbleToHand()
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
		Duel.SendtoHand(g,nil,REASON_EFFCT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.nfil2(c,tp)
	return c:IsType(TYPE_TOKEN) and c:IsControler(tp)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil2,1,nil,tp)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand() or c:IsCanBeSpecialSumoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_TOHAND,c,0,0,0)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,0,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if c:IsAbleToHand() and (not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetLocCount(tp,"M")<1
		or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==0) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	else
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(7)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
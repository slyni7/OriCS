--딥러닝 글로리
local m=18452740
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddDelightProcedure(c,nil,3,3,cm.pfun1)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,1,"N")
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
cm.custom_type=CUSTOMTYPE_DELIGHT
function cm.pfun1(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x2e7)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_DELIGHT)
end
function cm.tfil1(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("R") and chkc:IsControler(tp) and cm.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil1,tp,LSTN("R"),0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.tfil1,tp,LSTN("R"),0,2,2,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,2,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=0
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		ct=g:FilterCount(Card.IsLoc,nil,"H")
	end
	if ct<2 then
		Duel.Draw(tp,2-ct,REASON_EFFECT)
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost(POS_FACEDOWN)
	end
	Duel.Remove(c,POS_FACEDOWN,REASON_COST)
end
function cm.tfil2(c,e,tp,ec)
	return c:IsSetCard(0x2e7) and c:IsCustomType(CUSTOMTYPE_DELIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not c:IsCode(m) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(ec),c)>0
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"E",0,1,nil,e,tp,c)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"E",0,1,1,nil,e,tp,nil)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
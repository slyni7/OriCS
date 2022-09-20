--사일런트 머조리티: 1해
local m=18453098
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x2e0),1,1)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCountLimit(1,m+1)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,m+2)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=SilentMajorityGroups[tp]:Filter(function(c) return c:GetOriginalCode()==18453099 and c:IsAbleToHand() end,nil)
		return #g>0
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=SilentMajorityGroups[tp]:Filter(function(c) return c:GetOriginalCode()==18453099 and c:IsAbleToHand() end,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=SilentMajorityGroups[tp]:Filter(function(c) return c:GetOriginalCode()==18453084 and c:IsAbleToGraveAsCost() end,nil)
	if chk==0 then
		return #g>0
	end
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
end
function cm.tfil2(c,e,tp)
	return c:IsSetCard(0x2e0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and cm.tfil2(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IETarget(cm.tfil2,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil2,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
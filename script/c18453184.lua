--애타게 찾던 절실한 소원을 위해
local m=18453184
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","F")
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetDescription(aux.Stringid(m,0))
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","F")
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetDescription(aux.Stringid(m,1))
	WriteEff(e3,2,"C")
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","F")
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCountLimit(1,m)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"I","G")
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e5,5,"NCTO")
	c:RegisterEffect(e5)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(Card.IsDiscardable,tp,"H",0,1,nil) and c:GetFlagEffect(m)<1
	end
	c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,Card.IsDiscardable,tp,"H",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.tfil2(c)
	return c:IsSetCard(0x2e5) and c:IsAbleToGrave()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.tfil3(c)
	return c:IsSetCard(0x2e5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.tfil41(c)
	return c:IsSetCard(0x2e5) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function cm.tfil42(c,e,tp,m,exg)
	if c:GetType()&0x81~=0x81 or not c:IsSetCard(0x2e5) or not c:IsCanBeSpecialSummoned(e,0,tp,false,true) then
		return false
	end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(exg)
	if c.mat_filter then
		mg=mg:Filter(c.mtar_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	Auxiliary.GCheckAdditional=cm.tfun41(c,c:GetLevel())
	local res=mg:CheckSubGroup(cm.tfun42,1,c:GetLevel(),tp,c,c:GetLevel())
	Auxiliary.GCheckAdditional=nil
	return res
end
function cm.tfun41(c,lv)
	return
		function(g)
			return (not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g))
				and g:GetSum(cm.tval41,c)<=lv
		end
end
function cm.tval41(c,rc)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	end
	local raw_level=c:GetRitualLevel(rc)
	local lv1=raw_level&0xffff
	local lv2=raw_level>>16
	if lv2>0 then
		return math.min(lv1,lv2)
	else
		return lv1
	end
end
function cm.tfun42(g,tp,c,lv)
	return g:CheckWithSumEqual(cm.tval42,lv,#g,#g,c) and Duel.GetMZoneCount(tp,g,tp)>0
		and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not Auxiliary.RCheckAdditional or Auxiliary.RCheckAdditional(tp,g,c))
end
function cm.tval42(c,rc)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	end
	return c:GetRitualLevel(rc)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanOverlay,nil)
		local exg=Duel.GMGroup(cm.tfil41,tp,"G",0,nil)
		return Duel.IEMCard(cm.tfil42,tp,"H",0,1,nil,e,tp,mg,exg)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanOverlay,nil)
	local exg=Duel.GMGroup(cm.tfil41,tp,"G",0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SMCard(tp,cm.tfil42,tp,"H",0,1,1,nil,e,tp,mg,exg)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(exg)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local lv=tc:GetLevel()
		Auxiliary.GCheckAdditional=cm.tfun41(tc,tc:GetLevel())
		local mat=mg:SelectSubGroup(tp,cm.tfun42,false,1,lv,tp,tc,lv)
		Auxiliary.GCheckAdditional=nil
		tc:SetMaterial(mat)
		local mc=mat:GetFirst()
		while mc do
			local og=mc:GetOverlayGroup()
			Duel.SendtoGrave(og,REASON_RULE)
			mc=mat:GetNext()
		end
		local hg=mat:Filter(Card.IsLocation,nil,LOCATION_HAND)
		mat:Sub(hg)
		Duel.Overlay(tc,mat)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		Duel.Overlay(tc,hg)
		tc:CompleteProcedure()
	end
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LSTN("M"),0)==0
end
function cm.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.tfil5(c,e,tp)
	return c:IsSetCard(0x2e5) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and cm.tfil5(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil5,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil5,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
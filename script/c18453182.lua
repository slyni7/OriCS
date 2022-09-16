--날 묶어왓던 사슬을 벗어던진다
local m=18453182
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","G")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
end
function cm.tfil1(c,e,tp,m)
	if c:GetType()&0x81~=0x81 or not c:IsSetCard(0x2e5) or not c:IsCanBeSpecialSummoned(e,0,tp,false,true) then
		return false
	end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mtar_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	Auxiliary.GCheckAdditional=cm.tfun11(c,c:GetLevel())
	local res=mg:CheckSubGroup(cm.tfun12,1,c:GetLevel(),tp,c,c:GetLevel())
	Auxiliary.GCheckAdditional=nil
	return res
end
function cm.tfun11(c,lv)
	return
		function(g)
			return (not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g))
				and g:GetSum(cm.tval11,c)<=lv
		end
end
function cm.tval11(c,rc)
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
function cm.tfun12(g,tp,c,lv)
	return g:CheckWithSumEqual(cm.tval12,lv,#g,#g,c) and Duel.GetMZoneCount(tp,g,tp)>0
		and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not Auxiliary.RCheckAdditional or Auxiliary.RCheckAdditional(tp,g,c))
end
function cm.tval12(c,rc)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	end
	return c:GetRitualLevel(rc)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanOverlay,nil)
		return Duel.IEMCard(cm.tfil1,tp,"H",0,1,nil,e,tp,mg)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanOverlay,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SMCard(tp,cm.tfil1,tp,"H",0,1,1,nil,e,tp,mg)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local lv=tc:GetLevel()
		Auxiliary.GCheckAdditional=cm.tfun11(tc,tc:GetLevel())
		local mat=mg:SelectSubGroup(tp,cm.tfun12,false,1,lv,tp,tc,lv)
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
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LSTN("M"),0)==0
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.tfil2(c,e,tp)
	return c:IsSetCard(0x2e5) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and cm.tfil2(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil2,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil2,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
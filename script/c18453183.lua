--던지리라 바치리라
local m=18453183
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(aux.TargetBoolFunction(Card.IsSetCard,0x2e5))
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","S")
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","G")
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
end
function cm.tfil1(c)
	return c:IsFaceup() and c:IsSetCard(0x2e5)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and cm.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil1,tp,"M","M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local lv=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10,11,12)
	e:SetLabel(lv)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.STarget(tp,cm.tfil1,tp,"M","M",1,1,nil)
	Duel.SOI(0,CATEGORY_EQUIP,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		local e1=MakeEff(c,"E")
		if tc:IsType(TYPE_XYZ) then
			e1:SetCode(EFFECT_CHANGE_RANK)
		else
			e1:SetCode(EFFECT_CHANGE_LEVEL)
		end
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function cm.tfil3(c,e,tp,m)
	if c:GetType()&0x81~=0x81 or not c:IsSetCard(0x2e5) or not c:IsCanBeSpecialSummoned(e,0,tp,false,true) then
		return false
	end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mtar_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	Auxiliary.GCheckAdditional=cm.tfun31(c,c:GetLevel())
	local res=mg:CheckSubGroup(cm.tfun32,1,c:GetLevel(),tp,c,c:GetLevel())
	Auxiliary.GCheckAdditional=nil
	return res
end
function cm.tfun31(c,lv)
	return
		function(g)
			return (not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g))
				and g:GetSum(cm.tval31,c)<=lv
		end
end
function cm.tval31(c,rc)
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
function cm.tfun32(g,tp,c,lv)
	return g:CheckWithSumEqual(cm.tval32,lv,#g,#g,c) and Duel.GetMZoneCount(tp,g,tp)>0
		and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not Auxiliary.RCheckAdditional or Auxiliary.RCheckAdditional(tp,g,c))
end
function cm.tval32(c,rc)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	end
	return c:GetRitualLevel(rc)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanOverlay,nil)
		return Duel.IEMCard(cm.tfil3,tp,"HG",0,1,nil,e,tp,mg)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanOverlay,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SMCard(tp,cm.tfil3,tp,"HG",0,1,1,nil,e,tp,mg)
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
		Auxiliary.GCheckAdditional=cm.tfun31(tc,tc:GetLevel())
		local mat=mg:SelectSubGroup(tp,cm.tfun32,false,1,lv,tp,tc,lv)
		Auxiliary.GCheckAdditional=nil
		tc:SetMaterial(mat)
		Duel.Overlay(tc,mat)
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
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LSTN("M"),0)==0
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.tfil4(c,e,tp)
	return c:IsSetCard(0x2e5) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and cm.tfil4(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil4,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil4,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
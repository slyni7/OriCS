--RUM-Å¸ÀÓ½ºÄù¾î
local m=18452950
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.tfil11(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCustomType(CUSTOMTYPE_SQUARE)
		and Duel.IEMCard(cm.tfil12,tp,"E",0,1,nil,e,tp,c,rk+4)
		--and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function cm.tfil12(c,e,tp,mc,rk)
	return c:IsRank(rk) and c:IsType(TYPE_XYZ) and c:IsCustomType(CUSTOMTYPE_SQUARE) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil11,tp,"M",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.STarget(tp,cm.tfil11,tp,"M",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	--if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then	
	--	return
	--end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil12,tp,"E",0,1,1,nil,e,tp,tc,tc:GetRank()+4)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if #mg>0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
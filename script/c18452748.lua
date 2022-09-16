--인투 디 언논 딜라이트
local m=18452748
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function cm.tfil2(c)
	return c:IsCustomType(CUSTOMTYPE_DELIGHT) and c:IsDelightSummonable(nil)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"E",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,"E")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"E",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.DelightSummon(tp,tc,nil)
	end
end
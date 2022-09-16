--사이파이 크로마틱
local m=18452828
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_NORMALSUMMON,cm.afil1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.afil1)
end
function cm.afil1(c)
	return c:IsCustomType(CUSTOMTYPE_SQUARE)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_NORMALSUMMON)<1
			and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)<1
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.ctar11)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function cm.ctar11(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsCustomType(CUSTOMTYPE_SQUARE)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>1
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x2d7,0x80004011,0,1800,3,RACE_AQUA,ATTRIBUTE_LIGHT)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m+2,0x2d7,0x80004011,1800,0,3,RACE_THUNDER,ATTRIBUTE_WATER)
	end
	Duel.SOI(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x2d7,0x80004011,0,1800,3,RACE_AQUA,ATTRIBUTE_LIGHT)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+2,0x2d7,0x80004011,1800,0,3,RACE_THUNDER,ATTRIBUTE_WATER) then
		local token1=Duel.CreateToken(tp,m+1)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
		local token2=Duel.CreateToken(tp,m+2)
		Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end
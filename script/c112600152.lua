--欺界裝置(마키나)/日常(일상적인 날)
function c112600152.initial_effect(c)
	--아마 현존하는 스크립트 중에 가장 병신같은 스크립트가 될 듯
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(112600152,0))
	e1:SetCountLimit(1,112600152)
	e1:SetTarget(c112600152.tg1)
	e1:SetOperation(c112600152.ac1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetDescription(aux.Stringid(112600152,1))
	e2:SetCountLimit(1,112600152)
	e2:SetTarget(c112600152.tg2)
	e2:SetOperation(c112600152.ac2)
	c:RegisterEffect(e2)
	--Activate3
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetDescription(aux.Stringid(112600152,2))
	e3:SetCountLimit(1,112600152)
	e3:SetTarget(c112600152.tg3)
	e3:SetOperation(c112600152.ac3)
	c:RegisterEffect(e3)
	--Activate4
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetDescription(aux.Stringid(112600152,3))
	e4:SetCountLimit(1,112600152)
	e4:SetTarget(c112600152.tg4)
	e4:SetOperation(c112600152.ac4)
	c:RegisterEffect(e4)
	--Activate5
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetDescription(aux.Stringid(112600152,4))
	e5:SetCountLimit(1,112600152)
	e5:SetTarget(c112600152.tg5)
	e5:SetOperation(c112600152.ac5)
	c:RegisterEffect(e5)
	--Activate6
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e6:SetType(EFFECT_TYPE_ACTIVATE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetDescription(aux.Stringid(112600152,5))
	e6:SetCountLimit(1,112600152)
	e6:SetTarget(c112600152.tg6)
	e6:SetOperation(c112600152.ac6)
	c:RegisterEffect(e6)
	--summon
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_SUMMON)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e7:SetCountLimit(1,112600153)
	e7:SetCondition(c112600152.smcon)
	e7:SetTarget(c112600152.sumtg)
	e7:SetOperation(c112600152.sumop)
	c:RegisterEffect(e7)
end
function c112600152.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,112600129,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c112600152.ac1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,112600129,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,112600129)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c112600152.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,112600130,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c112600152.ac2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,112600130,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,112600130)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c112600152.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,112600131,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c112600152.ac3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,112600131,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,112600131)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c112600152.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,112600132,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c112600152.ac4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,112600132,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,112600132)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c112600152.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,112600133,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c112600152.ac5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,112600133,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,112600133)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c112600152.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,112600136,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c112600152.ac6(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,112600136,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,112600136)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c112600152.smcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c112600152.sumfilter(c)
	return c:IsSetCard(0xe89) and c:IsSummonable(true,nil)
end
function c112600152.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112600152.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c112600152.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c112600152.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
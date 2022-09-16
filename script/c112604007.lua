--생명의 마녀(아트릭시아) 퓨파
local m=112604007
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--DJ Beyond Festival
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(m,1))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetProperty(EFFECT_FLAG_DELAY)
	e10:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e10:SetCondition(cm.condition)
	e10:SetOperation(cm.djop)
	c:RegisterEffect(e10)
end

cm.CardType_ExRitual=true

--none
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end

--spsummon
function cm.spfilter(c,e,tp)
	return c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--DJ Beyond Festival
function cm.djop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	local val=1+math.floor(math.random()*3)
	if val==1 then
		local token=Duel.CreateToken(p,112700062)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			Duel.ConfirmCards(1-p,token)
	elseif val==2 then
		local token=Duel.CreateToken(p,112700066)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			Duel.ConfirmCards(1-p,token)	
	elseif val==3 then
		local token=Duel.CreateToken(p,112700064)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			Duel.ConfirmCards(1-p,token)		
	elseif val==4 then
		local token=Duel.CreateToken(p,112603339)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			Duel.ConfirmCards(1-p,token)				
	else
	end
end
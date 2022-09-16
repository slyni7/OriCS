--치천승자 아인
function c95481522.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd55),aux.NonTuner(Card.IsRace,RACE_FAIRY),1)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9342162,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,95481522)
	e1:SetTarget(c95481522.sptg)
	e1:SetOperation(c95481522.spop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c95481522.effcon)
	e2:SetOperation(c95481522.effop)
	c:RegisterEffect(e2)
end
function c95481522.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c95481522.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c95481522.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95481522.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetHandler():GetLevel())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c95481522.filter(c,e,tp,lv)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(lv-1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c95481522.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local lv=tc:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c95481522.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95481522.splimit(e,c)
	return not c:IsType(TYPE_EFFECT) and c:IsLocation(LOCATION_EXTRA)
end

function c95481522.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and not e:GetHandler():GetReasonCard():IsType(TYPE_EFFECT)
end
function c95481522.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95481522,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c95481522.indval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetValue(TYPE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e2,true)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95481507,2))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0xd55)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e3,true)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95481522,2))
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c95481522.efilter)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e4,true)
end
function c95481522.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_EFFECT)
end
function c95481522.indval(e,c)
	return not c:IsType(TYPE_NORMAL)
end
function c95481522.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end

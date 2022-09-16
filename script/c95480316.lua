--천명신룡 데스페라티오
function c95480316.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),10,3,c95480316.ovfilter,aux.Stringid(95480316,0),3)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c95480316.atkval)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c95480316.limcon)
	e2:SetTarget(c95480316.splimit1)
	c:RegisterEffect(e2)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(95480316,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c95480316.spcon)
	e5:SetTarget(c95480316.sptg)
	e5:SetOperation(c95480316.spop)
	c:RegisterEffect(e5)
	--atkup
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(95480316,2))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetLabelObject(e5)
	e6:SetCondition(c95480316.atkcon)
	e6:SetOperation(c95480316.atkop)
	c:RegisterEffect(e6)
end
function c95480316.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1d41) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0
end
function c95480316.atkfilter(c)
	return c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c95480316.atkval(e,c)
	return Duel.GetMatchingGroupCount(c95480316.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*1000
end

function c95480316.limcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0
end
function c95480316.splimit1(e,c,tp,sumtp,sumpos)
	return c:IsLocation(LOCATION_EXTRA)
end

function c95480316.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetOverlayCount()>0
end
function c95480316.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function c95480316.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	local ct=Duel.SendtoGrave(g,REASON_EFFECT)
	if ct>0 then
		e:SetLabel(ct)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end

function c95480316.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c95480316.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetLabelObject():GetLabel()*500
	if atk>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end

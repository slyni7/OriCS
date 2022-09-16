--검은 죽음의 형상 LV 9
function c95481303.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c95481303.immcon)
	e2:SetValue(c95481303.efilter)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,0xff)
	e3:SetValue(LOCATION_REMOVED)
	e3:SetTarget(c95481303.rmtg)
	c:RegisterEffect(e3)
	--register
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetCountLimit(1,95481303)
	e4:SetOperation(c95481303.regop)
	c:RegisterEffect(e4)
end

c95481303.lvup={95481302}
c95481303.lvdn={95481302,95481301}

function c95481303.immcon(e)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c95481303.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true
	else return aux.qlifilter(e,te) end
end

function c95481303.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end

function c95481303.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and rp~=tp and bit.band(r,REASON_DESTROY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetTarget(c95481303.sptg)
		e1:SetOperation(c95481303.spop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

function c95481303.filter(c,e,tp)
	return c:IsCode(95481301) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95481303.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c95481303.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c95481303.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95481303.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c95481303.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local sg=nil
		local hg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil)
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
		local b3=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
		local op=0
		if not b1 and not b2 and not b3 then return end
		if b1 then
			if b2 and b3 then
				op=Duel.SelectOption(tp,aux.Stringid(95481303,0),aux.Stringid(95481303,1),aux.Stringid(95481303,2))
			elseif b2 and not b3 then
				op=Duel.SelectOption(tp,aux.Stringid(95481303,0),aux.Stringid(95481303,1))
			elseif not b2 and b3 then
				op=Duel.SelectOption(tp,aux.Stringid(95481303,0),aux.Stringid(95481303,2))
				if op==1 then op=2 end
			else
				op=0
			end
		else
			if b2 and b3 then
				op=Duel.SelectOption(tp,aux.Stringid(95481303,1),aux.Stringid(95481303,2))+1
			elseif b2 and not b3 then
				op=1
			else
				op=2
			end
		end
		if op==0 then
			sg=hg:RandomSelect(tp,1)
		elseif op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(sg)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
			Duel.HintSelection(sg)
		end
		Duel.Remove(sg,nil,2,REASON_EFFECT)
	end
end
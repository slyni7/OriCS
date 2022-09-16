--타이니 에퀴녹스
function c95480102.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95480102,1))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,95480102)
	e1:SetTarget(c95480102.target)
	e1:SetOperation(c95480102.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c95480102.lcon)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,95480198)
	e3:SetCondition(c95480102.hspcon2)
	e3:SetCost(c95480102.hspcost)
	e3:SetTarget(c95480102.hsptg)
	e3:SetOperation(c95480102.hspop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP)
	e4:SetCondition(c95480102.hspcon)
	c:RegisterEffect(e4)
end

function c95480102.lcon(e,tp,eg,ep,ev,re,r,rp)
	local lg1=Duel.GetLinkedGroup(tp,1,1)
	local lg2=Duel.GetLinkedGroup(1-tp,1,1)
	lg1:Merge(lg2)
	return lg1 and lg1:IsContains(e:GetHandler())
end
function c95480102.filter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c95480102.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c95480102.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c95480102.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c95480102.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c95480102.posfilter(c)
	return not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function c95480102.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
	local tg=Duel.GetMatchingGroup(c95480102.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95480102,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local sg=tg:Select(tp,1,1,nil)
		Duel.ChangePosition(sg,POS_FACEUP_DEFENSE)
	end
end

function c95480102.cfilter(c,tp)
	return c:IsSetCard(0xd4f) and c:GetControler()==tp
end
function c95480102.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95480102.cfilter,1,nil,tp)
end
function c95480102.cfilter2(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsControler(tp)
end
function c95480102.hspcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95480102.cfilter2,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c95480102.rfilter(c)
	return (c:IsSetCard(0xd5f) or c:IsSetCard(0xd4f)) and c:IsAbleToRemoveAsCost()
end
function c95480102.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480102.rfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c95480102.rfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c95480102.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c95480102.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--사차원과 현세의 역전
function c95481319.initial_effect(c)
	aux.AddCodeList(c,25290459)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c95481319.val)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x41))
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(1)
	e3:SetCondition(c95481319.actcon)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(95481319,0))
	e4:SetCountLimit(1,95481319)
	e4:SetCondition(c95481319.con4)
	e4:SetCost(c95481319.cost4)
	e4:SetTarget(c95481319.tar4)
	e4:SetOperation(c95481319.op4)
	c:RegisterEffect(e4)
end
function c95481319.val(e,c)
	return c:GetLevel()*100
end
function c95481319.actfilter(c,tp)
	return c and c:IsFaceup() and c:IsSetCard(0x41) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c95481319.actcon(e)
	local tp=e:GetHandlerPlayer()
	return c95481319.actfilter(Duel.GetAttacker(),tp) or c95481319.actfilter(Duel.GetAttackTarget(),tp)
end
function c95481319.nfil4(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsPreviousSetCard(0x41)
		and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end
function c95481319.con4(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:IsExists(c95481319.nfil4,1,nil,tp,rp)
	g:KeepAlive()
	e:SetLabelObject(g)
	return #g>0
end
function c95481319.cfil4(c)
	return c:IsCode(25290459) and c:IsAbleToGraveAsCost()
end
function c95481319.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c95481319.cfil4,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c95481319.cfil4,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c95481319.tfil41(c,e,tp)
	local mt=getmetatable(c)
	return mt.lvup and Duel.IsExistingMatchingCard(c95481319.tfil42,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,mt)
end
function c95481319.tfil42(c,e,tp,mt)
	return c:IsCode(table.unpack(mt.lvup)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c95481319.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if chk==0 then
		return g:IsExists(c95481319.tfil41,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c95481319.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=e:GetLabelObject()
	if g:IsExists(c95481319.tfil41,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tc=g:FilterSelect(tp,c95481319.tfil41,1,1,nil,e,tp):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local mt=getmetatable(tc)
		local sg=Duel.SelectMatchingCard(tp,c95481319.tfil42,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,mt)
		Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)
	end
end
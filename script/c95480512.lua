--드라코센드 로드 레오
function c95480512.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WYRM),2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c95480512.actcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c95480512.con)
	e2:SetTarget(c95480512.distg)
	c:RegisterEffect(e2)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77539547,1))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,95480509)
	e5:SetCondition(c95480512.descon)
	e5:SetTarget(c95480512.destg)
	e5:SetOperation(c95480512.desop)
	c:RegisterEffect(e5)
end
function c95480512.actcon(e)
	local tc=Duel.GetAttacker()
	local tp=e:GetHandlerPlayer()
	return tc and tc:IsControler(tp) and tc:IsRace(RACE_BEASTWARRIOR) and tc:GetMutualLinkedGroupCount()>0
		and e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c95480512.con(e)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c95480512.distg(e,c)
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c95480512.descon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc~=e:GetHandler() and rc:GetLinkedGroup():IsContains(e:GetHandler())
end
function c95480512.filter(c)
	return c:IsAbleToRemove()
end
function c95480512.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480512.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c95480512.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c95480512.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c95480512.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
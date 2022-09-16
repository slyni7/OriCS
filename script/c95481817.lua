--크로노이드 가디언 세라핌
function c95481817.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c95481817.pfil1,2,true)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(c95481817.imcon)
	e1:SetOperation(c95481817.imop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(c95481817.val2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(c95481817.val3)
	c:RegisterEffect(e3)
	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95474755,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c95481817.extg)
	e4:SetOperation(c95481817.exop)
	c:RegisterEffect(e4)
end
function c95481817.pfil1(c)
	return c:IsFusionSetCard(0xd54)
end
function c95481817.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c95481817.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c95481817.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c95481817.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c95481817.vfil2(c)
	return c:IsFaceup() and c:IsType(TYPE_UNION)
end
function c95481817.val2(e,c)
	return c:GetEquipGroup():FilterCount(c95481817.vfil2,nil)*500
end
function c95481817.val3(e,c)
	return c:GetEquipGroup():FilterCount(c95481817.vfil2,nil)
end

function c95481817.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetEquipGroup():FilterCount(c95481817.vfil2,nil)
	local tg=Duel.GetDecktopGroup(1-tp,ct)
	if chk==0 then return ct>0
		and tg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==ct end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct,1-tp,LOCATION_DECK)
end
function c95481817.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetEquipGroup():FilterCount(c95481817.vfil2,nil)
	if ct==0 then return end
	local tg=Duel.GetDecktopGroup(1-tp,ct)
	Duel.DisableShuffleCheck()
	Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
end

--드라코센드 리브라
function c95480510.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xd5b),2,2)
	c:EnableReviveLimit()
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c95480510.atkcon)
	e1:SetTarget(c95480510.atktg)
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77539547,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,95480510)
	e3:SetCondition(c95480510.descon)
	e3:SetTarget(c95480510.destg)
	e3:SetOperation(c95480510.desop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetCondition(c95480510.rmcon1)
	e4:SetOperation(c95480510.rmop1)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_TO_HAND)
	e5:SetCondition(c95480510.regcon)
	e5:SetOperation(c95480510.regop)
	e5:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetCondition(c95480510.rmcon2)
	e6:SetOperation(c95480510.rmop2)
	e6:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e6)
end
function c95480510.descon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc~=e:GetHandler() and rc:GetLinkedGroup():IsContains(e:GetHandler())
end
function c95480510.filter(c,e,tp)
	return c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95480510.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c95480510.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c95480510.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c95480510.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c95480510.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c95480510.atkcon(e)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c95480510.atktg(e,c)
	return c:GetMutualLinkedGroupCount()==0
end
function c95480510.cfilter(c,tp)
	return c:IsControler(1-tp) and not c:IsReason(REASON_DRAW) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function c95480510.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95480510.cfilter,1,nil,tp) and e:GetHandler():GetMutualLinkedGroupCount()>0
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c95480510.rmop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,95480510)
	local tg=Duel.GetDecktopGroup(1-tp,3)
	Duel.DisableShuffleCheck()
	Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
end
function c95480510.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95480510.cfilter,1,nil,tp) and Duel.GetFlagEffect(tp,95480510)==0 and e:GetHandler():GetMutualLinkedGroupCount()>0
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c95480510.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,95480510,RESET_CHAIN,0,1)
end
function c95480510.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,95480510)>0 and e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c95480510.rmop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,95480510)
	Duel.Hint(HINT_CARD,0,95480510)
	local tg=Duel.GetDecktopGroup(1-tp,3)
	Duel.DisableShuffleCheck()
	Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
end
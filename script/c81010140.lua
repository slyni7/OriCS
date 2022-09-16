--MMJ : Ruisui no Denrei

function c81010140.initial_effect(c)
	
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c81010140.alvl)
	e1:SetCondition(c81010140.alcon)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010140,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,81010140)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c81010140.cn)
	e2:SetTarget(c81010140.tg)
	e2:SetOperation(c81010140.op)
	c:RegisterEffect(e2)
end

--act limit (e1)
function c81010140.alvl(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c81010140.alcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

--effect
function c81010140.cn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c81010140.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_HAND)
end
function c81010140.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,2)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
	Duel.ShuffleDeck(1-tp)
end

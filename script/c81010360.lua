--혼령검

function c81010360.initial_effect(c)

	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c81010360.idco)
	e1:SetTarget(c81010360.idtg)
	e1:SetOperation(c81010360.idop)
	c:RegisterEffect(e1)
	
	--return to deck + 1 draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010360,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81010360)
	e2:SetCost(c81010360.ddco)
	e2:SetTarget(c81010360.ddtg)
	e2:SetOperation(c81010360.ddop)
	c:RegisterEffect(e2)
	
end

--indes
function c81010360.idcofilter(c)
	return c:IsSetCard(0xca1) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c81010360.idco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81010360.idcofilter,tp,LOCATION_GRAVE,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c81010360.idcofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

function c81010360.idtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsLocation(LOCATION_MZONE)
			and chkc:IsControler(tp)
			and chkc:IsFaceup()
			end
	if chk==0 then return
				Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end

function c81010360.idop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(600)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(c81010360.idopfilter)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c81010360.idopfilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

--return to deck + 1 draw
function c81010360.ddco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				c:IsAbleToRemoveAsCost()
			end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function c81010360.ddtgfilter(c)
	return c:IsFaceup() 
	   and c:IsSetCard(0xca1) and c:IsAbleToDeck()
end
function c81010360.ddtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsLocation(LOCATION_REMOVED)
			and chkc:IsControler()
			and c81010360.ddtgfilter(chkc)
			end
	if chk==0 then return 
				Duel.IsPlayerCanDraw(tp,1)
			and Duel.IsExistingTarget(c81010360.ddtgfilter,tp,LOCATION_REMOVED,0,3,e:GetHandler())
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81010360.ddtgfilter,tp,LOCATION_REMOVED,0,3,3,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function c81010360.ddop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end

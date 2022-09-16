--MMJ Reimusha
function c81010080.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c81010080.tfilter),1)
	c:EnableReviveLimit()
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c81010080.alvl)
	e2:SetCondition(c81010080.alcon)
	c:RegisterEffect(e2)
	--send to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81010080,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c81010080.tdco)
	e3:SetTarget(c81010080.tdtg)
	e3:SetOperation(c81010080.tdop)
	c:RegisterEffect(e3)
end

--synchro summon
function c81010080.tfilter(c)
	return c:IsSetCard(0xca1) and c:IsType(TYPE_SYNCHRO)
end

--cannot be targeted
function c81010080.cntgvl(e,re,rp)
	return rp~=e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end

--act limit
function c81010080.alvl(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c81010080.alcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

--send to deck
function c81010080.tdcofilter(c)
	return c:IsSetCard(0xca1) and c:IsAbleToDeckAsCost()
end
function c81010080.tdco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010080.tdcofilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local cg=Duel.SelectMatchingCard(tp,c81010080.tdcofilter,tp,LOCATION_GRAVE,0,1,2,nil)
	e:SetLabel(cg:GetCount())
	Duel.SendtoDeck(cg,nil,2,REASON_COST)
end

function c81010080.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cg=e:GetLebel()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c81010080.tdtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,cg,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,cg,cg,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c81010080.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end



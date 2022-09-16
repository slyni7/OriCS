--여랑발호

function c81010330.initial_effect(c)

	--bounce
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c81010330.bcco)
	e1:SetTarget(c81010330.bctg)
	e1:SetOperation(c81010330.bcop)
	c:RegisterEffect(e1)
	
	--send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010330,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81010330)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81010330.gdtg)
	e2:SetOperation(c81010330.gdop)
	c:RegisterEffect(e2)
	
end

--bounce
function c81010330.bccofilter(c)
	return c:IsAbleToRemoveAsCost()
	   and c:IsRace(RACE_BEASTWARRIOR)
end
function c81010330.bcco(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_GRAVE+LOCATION_MZONE
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81010330.bccofilter,tp,loc,0,1,nil)
			end
	local g=Duel.SelectMatchingCard(tp,c81010330.bccofilter,tp,loc,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c81010330.bctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsOnField()
			and chkc:IsAbleToHand()
			and chkc:IsControler(1-tp)
			end
	if chk==0 then return
				Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end

function c81010330.bcop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end

--send to grave
function c81010330.gdtgfilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xca1)
end
function c81010330.gdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81010330.gdtgfilter,tp,LOCATION_DECK,0,1,nil)
			end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function c81010330.gdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81010330.gdtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

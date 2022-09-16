--리리컬 BLAST(레이) {아카데미 데이지}
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not AshBlossomTable then AshBlossomTable={} end
	table.insert(AshBlossomTable,e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target1)
	e2:SetOperation(s.operation1)
	c:RegisterEffect(e2)
	--negate
	local e30=Effect.CreateEffect(c)
	e30:SetCategory(CATEGORY_DISABLE)
	e30:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e30:SetCode(EVENT_CHAIN_SOLVING)
	e30:SetRange(LOCATION_FZONE)
	e30:SetCondition(s.negcon)
	e30:SetOperation(s.negop)
	c:RegisterEffect(e30)
end
function s.thfilter(c)
	return c:IsSetCard(0xe79) and c:IsAbleToGrave()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.filter1(c)
	return c:IsSetCard(0xe79) and c:IsAbleToHand()
end
function s.nfil111(c,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and c:IsSetCard(0xe79) and Duel.IsExistingMatchingCard(s.nfil112,tp,LOCATION_MZONE,0,1,c,lv)
end
function s.nfil112(c,lv)
	return c:IsLevel(lv) and c:IsFaceup() and c:IsSetCard(0xe79)
end
function s.nfil12(c)
	local lv=c:GetLevel()
	return lv==0 and c:IsFaceup() and c:IsSetCard(0xe79)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_GRAVE
	if Duel.IsExistingMatchingCard(s.nfil111,tp,LOCATION_MZONE,0,1,nil,tp)
		or Duel.IsExistingMatchingCard(s.nfil12,tp,LOCATION_MZONE,0,1,nil) then
		loc=loc|LOCATION_DECK
	end
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,loc,0,1,nil) end
	e:SetLabel(loc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local loc=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,loc,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.nfil13(c)
	return c:IsFaceup() and c:IsCode(112604200)
end
--negate
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp 
 		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
			and e:GetHandler():GetFlagEffect(id)<=0
		and (Duel.IsExistingMatchingCard(s.nfil12,tp,LOCATION_MZONE,0,1,nil) or Duel.IsExistingMatchingCard(s.nfil13,tp,LOCATION_ONFIELD,0,1,nil))
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		if Duel.NegateEffect(ev) then
			Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		end
	end
end
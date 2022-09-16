--MMJ : Esakure! Esa!

function c81010150.initial_effect(c)
	
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c81010150.drco)
	e1:SetTarget(c81010150.drtg)
	e1:SetOperation(c81010150.drop)
	c:RegisterEffect(e1)
end

--activate
function c81010150.drcofilter(c)
	return c:IsSetCard(0xca1) and c:IsDiscardable()
end
function c81010150.drco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010150.drcofilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c81010150.drcofilter,1,1,REASON_COST+REASON_DISCARD,nil)
end

function c81010150.fil(c)
	return c:IsSetCard(0xca1) and c:IsType(TYPE_MONSTER)
end
function c81010150.tfil(c)
	return c:IsSetCard(0xca1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c81010150.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local gc=Duel.GetMatchingGroup(c81010150.fil,tp,LOCATION_GRAVE,0,fil):GetClassCount(Card.GetCode)
	if chk==0 then 
		return Duel.IsPlayerCanDraw(tp,2) 	
	end
	if gc>2 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c81010150.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local gc=Duel.GetMatchingGroup(c81010150.fil,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	if gc>3 and Duel.SelectYesNo(tp,aux.Stringid(81010150,0)) then
		local g=Duel.GetMatchingGroup(c81010150.tfil,tp,LOCATION_GRAVE,0,nil)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

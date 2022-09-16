--欺界裝置(마키나)/正規/710(니나)
function c112600143.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2,2,c112600143.lcheck)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112600143,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,112600143)
	e1:SetCondition(c112600143.thcon)
	e1:SetTarget(c112600143.thtg)
	e1:SetOperation(c112600143.thop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112600143,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c112600143.cost)
	e2:SetTarget(c112600143.target)
	e2:SetOperation(c112600143.operation)
	c:RegisterEffect(e2)
	--atk & def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c112600143.atktg)
	e3:SetValue(700)
	c:RegisterEffect(e3)
	local e0=e3:Clone()
	e0:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e0)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,112600143)
	e4:SetCondition(c112600143.tkcn)
	e4:SetTarget(c112600143.tktg)
	e4:SetOperation(c112600143.tkop)
	c:RegisterEffect(e4)
end
function c112600143.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xe89)
end
function c112600143.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c112600143.thfilter(c)
	return c:IsSetCard(0xe89) and c:IsAbleToHand()
end
function c112600143.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(c112600143.thfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112600143.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c112600143.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg3=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		Duel.ConfirmCards(1-tp,sg1)
		local cg=sg1:RandomSelect(1-tp,1)
		local tc=cg:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
function c112600143.cfilter(c,g)
	return g:IsContains(c)
end
function c112600143.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c112600143.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c112600143.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c112600143.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c112600143.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	end
end
function c112600143.atktg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0xe89)
end
function c112600143.tkcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
	and bit.band(c:GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c112600143.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,112600130,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c112600143.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,112600130,0xe89,0x4004001,500,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) then
		return
	end
	local token=Duel.CreateToken(tp,112600130)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
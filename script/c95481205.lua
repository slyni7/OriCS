--파라바이오트 웜
function c95481205.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCondition(c95481205.hspcon)
	e0:SetOperation(c95481205.hspop)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10813327,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c95481205.tdcon)
	e1:SetTarget(c95481205.tdtg)
	e1:SetOperation(c95481205.tdop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9156135,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetTarget(c95481205.tdtg)
	e3:SetOperation(c95481205.tdop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98700941,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetCondition(c95481205.spcon)
	e4:SetTarget(c95481205.sptg)
	e4:SetOperation(c95481205.spop)
	c:RegisterEffect(e4)
	--handes
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(58481572,0))
	e5:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_HAND)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,95481205)
	e5:SetCondition(c95481205.hdcon)
	e5:SetTarget(c95481205.hdtg)
	e5:SetOperation(c95481205.hdop)
	c:RegisterEffect(e5)
end

function c95481205.hspfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd47) and c:IsControler(tp)
end
function c95481205.hspfilter2(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd47) and (c:IsControler(tp) or c:IsLocation(LOCATION_HAND))
end
function c95481205.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=0
	if Duel.CheckReleaseGroup(tp,c95481205.hspfilter,1,nil,tp) then ct=ct-1 end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>ct
		and Duel.CheckReleaseGroupEx(tp,c95481205.hspfilter2,2,e:GetHandler(),tp)
end
function c95481205.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then
		local g=Duel.SelectReleaseGroupEx(tp,c95481205.hspfilter2,2,2,e:GetHandler(),tp)
		Duel.Release(g,REASON_COST)
	elseif ft==0 then
		local g=Duel.SelectReleaseGroupEx(tp,c95481205.hspfilter2,2,2,e:GetHandler(),tp)
		Duel.Release(g,REASON_COST)
	else
		local g1=Duel.SelectReleaseGroup(tp,c95481205.hspfilter,2,2,e:GetHandler(),tp)
		Duel.Release(g1,REASON_COST)
	end
end

function c95481205.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c95481205.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c95481205.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(c,1-tp,2,REASON_EFFECT)
	if not c:IsLocation(LOCATION_DECK) then return end
	Duel.ShuffleDeck(1-tp)
	c:ReverseInDeck()
end

function c95481205.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetControler()~=c:GetOwner()
end
function c95481205.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c95481205.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
	if sg and Duel.Destroy(sg,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(c95481205.tgcon)
	e1:SetOperation(c95481205.tgop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95481205.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetControler()~=c:GetOwner()
end
function c95481205.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
function c95481205.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c95481205.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c95481205.cfilter,1,nil,1-tp)
end
function c95481205.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) 
		and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c95481205.thfilter(c)
	return c:IsSetCard(0xd47) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c95481205.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(95481202,0))
			local tg=Duel.GetMatchingGroup(c95481205.thfilter,tp,0,LOCATION_DECK,nil)
			if tg:GetCount()==0 then return end
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOHAND)
			local g=tg:Select(1-tp,1,1,nil)
			if g:GetCount()>0 then
				if Duel.SendtoHand(g,1-tp,REASON_EFFECT)==0 then
					Duel.ShuffleDeck(1-tp)
				end
			end
		end
	end
end

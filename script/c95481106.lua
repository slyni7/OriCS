--아르스 게티아 - 아몬
function c95481106.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,95481106+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c95481106.sprcon)
	e2:SetOperation(c95481106.sprop)
	c:RegisterEffect(e2)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95481106,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c95481106.hdcon)
	e3:SetTarget(c95481106.hdtg)
	e3:SetOperation(c95481106.hdop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCountLimit(1,95481105)
	e4:SetTarget(c95481106.rmtg)
	e4:SetOperation(c95481106.rmop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
end

function c95481106.nfil11(c,sc,tp)
	return ((c:IsReleasable() and c:IsLocation(LOCATION_HAND+LOCATION_MZONE))
		or (c:IsAbleToRemoveAsCost() and c:IsLocation(LOCATION_GRAVE)
			and c:IsSetCard(0xd5c) and sc:IsHasEffect(95481113,tp))) and c:IsLevelAbove(1) and c:IsSummonableCard()
end
function c95481106.nfil12(c,tp,g,sg,sc)
	sg:AddCard(c)
	local res=false
	if sg:CheckWithSumGreater(Card.GetLevel,sc:GetLevel()) then
		res=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or sg:IsExists(c95481106.nfil13,1,nil,tp)
	else
		res=g:IsExists(c95481106.nfil12,1,sg,tp,g,sg,sc)
	end
	sg:RemoveCard(c)
	return res
end
function c95481106.nfil13(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c95481106.sprcon(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c95481106.nfil11,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c,c,tp)
	local sg=Group.CreateGroup()
	return g:IsExists(c95481106.nfil12,1,nil,tp,g,sg,c)
end
function c95481106.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c95481106.nfil11,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c,c,tp)
	local sg=Group.CreateGroup()
	while not sg:CheckWithSumGreater(Card.GetLevel,c:GetLevel()) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mg=g:FilterSelect(tp,c95481106.nfil12,1,1,sg,tp,g,sg,c)
		sg:Merge(mg)
	end
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	sg:Sub(rg)
	if #rg>0 then
	local te=c:IsHasEffect(95481113,tp)
	te:UseCountLimit(tp)
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.Release(sg,REASON_COST)
end

function c95481106.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c95481106.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c95481106.cfilter,1,nil,1-tp)
end
function c95481106.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c95481106.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end

function c95481106.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(1-tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil,1-tp,POS_FACEDOWN)==3 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,1-tp,LOCATION_DECK)
end
function c95481106.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	if ct==0 then return end
	if ct>3 then ct=3 end
	local g=Duel.GetDecktopGroup(1-tp,ct)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end


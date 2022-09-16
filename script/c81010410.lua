--요술사

function c81010410.initial_effect(c)

	--summon method
	
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c81010410.splm)
	c:RegisterEffect(e1)
	
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,81010410)
	e2:SetCondition(c81010410.spcn)
	e2:SetTarget(c81010410.sptg)
	e2:SetOperation(c81010410.spop)
	c:RegisterEffect(e2)
	
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81010410,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81010411)
	e3:SetCondition(c81010410.ngcn)
	e3:SetCost(c81010410.ngco)
	e3:SetTarget(c81010410.ngtg)
	e3:SetOperation(c81010410.ngop)
	c:RegisterEffect(e3)
	
	--return to hand + damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81010410,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,81010412)
	e4:SetCost(c81010410.ddco)
	e4:SetTarget(c81010410.ddtg)
	e4:SetOperation(c81010410.ddop)
	c:RegisterEffect(e4)
	
end

--summon method
function c81010410.splm(e,se,sp,st)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_HAND)
	   and bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end

--special summon
function c81010410.spcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end

function c81010410.sptgfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
	   and c:IsLevelBelow(7)
	   and ( c:IsSetCard(0xca1) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) )
end
function c81010410.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_GRAVE+LOCATION_REMOVED
	if chkc then return
				chkc:IsLocation(loc)
			and chkc:IsControler(tp)
			and c81010410.sptgfilter(chkc,e,tp)
			end
	if chk==0 then return
				Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c81010410.sptgfilter,tp,loc,0,1,nil,e,tp)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81010410.sptgfilter,tp,loc,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c81010410.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP_ATTACK)
	end
end

--negate
function c81010410.ngcn(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) 
	   and re:IsHasType(EFFECT_TYPE_ACTIVATE)
	   and Duel.IsChainNegatable(ev)
end

function c81010410.ngcofilter(c)
	return (c:IsFaceup() or c:IsLocation(0x02)) and c:IsReleasableByEffect() and c:IsRace(RACE_BEASTWARRIOR)
end
function c81010410.ngco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=LOCATION_HAND+LOCATION_MZONE
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81010410.ngcofilter,tp,loc,0,1,c)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81010410.ngcofilter,tp,loc,0,1,1,c)
	Duel.Release(g,REASON_COST)
end

function c81010410.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end

function c81010410.ngop(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	Duel.NegateActivation(ev)
	if ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
	end
end

--return to hand + damage
function c81010410.ddco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				c:IsReleasable()
			end
	Duel.Release(c,REASON_COST)
end

function c81010410.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*100)
end

function c81010410.ddop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_EXTRA)
	Duel.Damage(1-tp,ct*200,REASON_EFFECT)
end
